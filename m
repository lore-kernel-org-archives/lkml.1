Return-Path: <linux-kernel-owner+w=401wt.eu-S1751298AbXCHDB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbXCHDB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 22:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXCHDB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 22:01:59 -0500
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:34239 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbXCHDB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 22:01:58 -0500
From: Kandan Venkataraman <kven709@cse.unsw.EDU.AU>
To: linux-kernel@vger.kernel.org
Date: Thu, 8 Mar 2007 14:01:47 +1100 (EST)
X-X-Sender: kven709@williams.orchestra.cse.unsw.EDU.AU
cc: akpm@linux-foundation.org
Subject: [PATCH] Loop device - Tracking page writes made to a loop device
 through mmap
Message-ID: <Pine.LNX.4.64.0703081342000.21734@williams.orchestra.cse.unsw.EDU.AU>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1585517810-124106876-1173322907=:21734"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1585517810-124106876-1173322907=:21734
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed


All comments have been taken care of.

Description:

A  file_operations structure variable called loop_fops is initialised with 
the default block device file operations (def_blk_fops).
The mmap operation is overriden with a new function called loop_file_mmap.

A vm_operations structure variable called loop_file_vm_ops is initialised 
with the default operations for a disk file.
The page_mkwrite operation in this variable is initialised to a new 
function called loop_track_pgwrites.

In the function lo_open, the file operations pointer of the device file is 
initialised with the address of loop_fops.

The function loop_file_mmap simply calls generic_file_mmap and then 
initialises the vm_ops of the vma with address of loop_file_vm_ops.

The function loop_track_pgwrites stores the page offset of the page that 
is being written to,  in a red-black tree within the loop device.

A flag lo_track_pgwrite has been added to the structs loop_device and 
loop_info64 to turn on/off tracking of page writes.

Two new ioctls have been added.

The ioctl cmd LOOP_GET_PGWRITES retrieves the page offsets of pages that 
have been written to.
The ioctl cmd LOOP_CLR_PGWRITES empties the red-black tree

This functionality would allow us to have a read only version and a write 
version of memory by doing the following:
Associate a normal file as backing storage for  the loop device and mmap 
to the loop device. Call this mmapped address space as area1.
Mmap to a normal file of identical size. Call this mmapped address space 
as area2.

Changes made to area1 can be periodically copied to area2 using the ioctl 
cmds (retreive dirty page offsets and copy the dirty pages from area1 to 
area2). This facility would provide a quick way of updating the read only 
version.

Motivation for new ioctls:

Imagine a business server application which processes messages from 
clients as they come in (say over a TCP connection).
Some of those messages may be transactions, i.e. they cause data changes 
in the application.
Rest of those messages may be queries i.e. they get information from the 
application.
The application can consist of two processes. One process will handle the 
transactions.
The other process will handle the queries. Each process will have its own 
copy of the business data.
The process handling transactions can mmap to the loop device for its copy 
of the memory. The loop device must have a normal file for its backing 
storage.
The process handling queries can mmap to another normal file for its copy 
of the memory.  Both these memories have identical data at the beginning.
Queries and transactions can now be handled simultaneously by the 
respective processes.
The query process can update its memory periodically by obtaining the 
changes that have have happened to the loop device.
By using the ioctl call to retrieve the dirty page offsets, only the dirty 
pages need to be copied over to the query process's copy of memory. We can 
infact have multiple processes to handle queries sharing the same memory.
During this copy over, the transaction process will hold off processing 
transactions till the update is complete.

This would be very useful for high speed in-memory transaction systems, 
where the query load can be passed of to other processes. Example of such 
systems would be a stock trading system, where clients buy and sell
stock(equity, options etc).
At the same time lot of clients would be downloading market data and this 
can be done independently of the transactions.

This new facility will provide a way of tracking changes made to business 
data, independent of the application domain.


Test program:

Before you run the test program, please create the backing storage file
for the loop device as follows

dd if=/dev/zero of=/root/file bs=4K count=10

Set bs to be whatever pagesize is in your machine. In my machine it was 
4K.


#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>
#include <assert.h>
#include <signal.h>
#include <errno.h>
#include <linux/loop.h>

int main()
{
  	int maxPages = 10;
  	char* start = 0;
  	int fd;
  	int dfd;
  	int *array = 0;
  	int pageSize;
  	int elemsPerPage;
  	struct loop_info64 info;
  	struct loop_pgoff_array pgarray;
  	pgarray.max = maxPages;

  	pgarray.pgoff = calloc(maxPages, sizeof(long));

  	if (pgarray.pgoff == NULL) {
  		fprintf(stderr, "can't create pgarray\n");
  		exit(1);
  	}
  	pageSize = getpagesize();

  	elemsPerPage = pageSize/sizeof(int);

  	/* open the device file */
  	if ((fd = open ("/dev/loop0", O_RDWR, S_IRWXU)) < 0) {
  		fprintf(stderr, "can't create device file for writing\n");
  		goto out5;
  	}
  	/* open the disk file  to set as backing storage*/
  	if ((dfd = open ("/root/file", O_RDWR, S_IRWXU)) < 0) {
  		fprintf(stderr, "can't create device file for writing\n");
  		goto out4;
  	}
  	if (ioctl(fd, LOOP_SET_FD, dfd) < 0) {
  		perror("ioctl: LOOP_SET_FD");
  		goto out3;
  	}
  	if ((start = mmap(0, maxPages * pageSize, PROT_READ | PROT_WRITE,
 			  MAP_SHARED, fd, 0)) == MAP_FAILED) {
  		perror("mmap error");
  		goto out2;
  	}
  	if (ioctl(fd, LOOP_GET_STATUS64, &info) < 0) {
  		perror("ioctl: LOOP_CLR_PGWRITES");
  		goto out1;
  	}
  	info.lo_track_pgwrite = 1;

  	if (ioctl(fd, LOOP_SET_STATUS64, &info) < 0) {
  		perror("ioctl: LOOP_SET_STATUS64");
  		goto out1;
  	}
  	if (ioctl(fd, LOOP_CLR_PGWRITES, 0) < 0) {
  		perror("ioctl: LOOP_CLR_PGWRITES");
  		goto out1;
  	}
  	array = (int *)start;

  	array[0] = 5;

  	fprintf(stderr, "value = %d\n", array[0]);

  	array[1] = 9;

  	fprintf(stderr, "value = %d\n", array[1]);

  	array[elemsPerPage] = 14;

  	fprintf(stderr, "value = %d\n", array[elemsPerPage]);

  	array[3*elemsPerPage+60] = 35;

  	fprintf(stderr, "value = %d\n", array[3*elemsPerPage+60]);

  	if (ioctl(fd, LOOP_GET_PGWRITES, &pgarray) < 0) {
  		perror("ioctl: LOOP_GET_PGWRITES");
  		goto out1;
  	}
  	int i;
  	for (i= 0; i < pgarray.num; i++)
  		fprintf(stderr, "offset %ld\n", pgarray.pgoff[i]);

out1:
  	munmap(start, maxPages * pageSize);
out2:
  	ioctl(fd, LOOP_CLR_FD, 0);
out3:
  	close(dfd);
out4:
  	close(fd);
out5:
  	return 0;
}




Signed-off-by: Kandan Venkataraman kandan.venkataraman@omxgroup.com



--1585517810-124106876-1173322907=:21734
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0703081401470.21734@williams.orchestra.cse.unsw.EDU.AU>
Content-Description: 
Content-Disposition: attachment; filename=patch

ZGlmZiAtdXByTiBsaW51eC0yLjYuMTkuMi9kcml2ZXJzL2Jsb2NrL2xvb3Au
YyBsaW51eC0yLjYuMTkuMi1uZXcvZHJpdmVycy9ibG9jay9sb29wLmMNCi0t
LSBsaW51eC0yLjYuMTkuMi9kcml2ZXJzL2Jsb2NrL2xvb3AuYwkyMDA3LTAz
LTAzIDE2OjI2OjAzLjAwMDAwMDAwMCArMTEwMA0KKysrIGxpbnV4LTIuNi4x
OS4yLW5ldy9kcml2ZXJzL2Jsb2NrL2xvb3AuYwkyMDA3LTAzLTAzIDE2OjQ0
OjM4LjAwMDAwMDAwMCArMTEwMA0KQEAgLTc0LDEyICs3NCwxNiBAQA0KICNp
bmNsdWRlIDxsaW51eC9oaWdobWVtLmg+DQogI2luY2x1ZGUgPGxpbnV4L2dm
cC5oPg0KICNpbmNsdWRlIDxsaW51eC9rdGhyZWFkLmg+DQorI2luY2x1ZGUg
PGxpbnV4L21tLmg+DQogDQogI2luY2x1ZGUgPGFzbS91YWNjZXNzLmg+DQog
DQogc3RhdGljIGludCBtYXhfbG9vcCA9IDg7DQogc3RhdGljIHN0cnVjdCBs
b29wX2RldmljZSAqbG9vcF9kZXY7DQogc3RhdGljIHN0cnVjdCBnZW5kaXNr
ICoqZGlza3M7DQorc3RhdGljIGttZW1fY2FjaGVfdCAqcGdvZmZfZWxlbV9j
YWNoZTsNCitzdGF0aWMgY2hhciAqY2FjaGVfbmFtZSA9ICJsb29wX3Bnb2Zm
X2VsZW1fY2FjaGUiOw0KK3N0YXRpYyBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25z
IGxvb3BfZm9wczsNCiANCiAvKg0KICAqIFRyYW5zZmVyIGZ1bmN0aW9ucw0K
QEAgLTY0Niw2ICs2NTAsNzAgQEAgc3RhdGljIHZvaWQgZG9fbG9vcF9zd2l0
Y2goc3RydWN0IGxvb3BfZA0KIAljb21wbGV0ZSgmcC0+d2FpdCk7DQogfQ0K
IA0KK3N0YXRpYyB2b2lkIHBnb2ZmX3RyZWVfY2xlYXIoc3RydWN0IHJiX3Jv
b3QgKnJiX3Jvb3QpDQorew0KKwlzdHJ1Y3QgcmJfbm9kZSAqcmJfbm9kZSAg
PSByYl9yb290LT5yYl9ub2RlOw0KKw0KKwl3aGlsZSAocmJfbm9kZSAhPSBO
VUxMKSB7DQorDQorCQlyYl9lcmFzZShyYl9ub2RlLCByYl9yb290KTsNCisJ
CWttZW1fY2FjaGVfZnJlZShwZ29mZl9lbGVtX2NhY2hlLCByYl9lbnRyeShy
Yl9ub2RlLCANCisJCQkJc3RydWN0IHBnb2ZmX2VsZW0sIG5vZGUpKTsNCisJ
CXJiX25vZGUgPSByYl9yb290LT5yYl9ub2RlOw0KKwl9DQorDQorCSpyYl9y
b290ID0gUkJfUk9PVDsNCit9DQorDQorDQorc3RhdGljIGludCBsb29wX2Ns
cl9wZ3dyaXRlcyhzdHJ1Y3QgbG9vcF9kZXZpY2UgKmxvKQ0KK3sNCisJc3Ry
dWN0IGZpbGUgKmZpbHAgPSBsby0+bG9fYmFja2luZ19maWxlOw0KKw0KKwlp
ZiAobG8tPmxvX3N0YXRlICE9IExvX2JvdW5kKQ0KKwkJcmV0dXJuIC1FTlhJ
TzsNCisNCisJaWYgKGZpbHAgPT0gTlVMTCB8fCAhbG8tPmxvX3RyYWNrX3Bn
d3JpdGUpDQorCQlyZXR1cm4gLUVJTlZBTDsNCisNCisJcGdvZmZfdHJlZV9j
bGVhcigmbG8tPnBnb2ZmX3RyZWUpOw0KKw0KKwlyZXR1cm4gMDsNCit9DQor
DQorc3RhdGljIGludCBsb29wX2dldF9wZ3dyaXRlcyhzdHJ1Y3QgbG9vcF9k
ZXZpY2UgKmxvLCANCisJCQkgICAgIHN0cnVjdCBsb29wX3Bnb2ZmX2FycmF5
IF9fdXNlciAqYXJnKQ0KK3sNCisJc3RydWN0IGZpbGUgKmZpbHAgPSBsby0+
bG9fYmFja2luZ19maWxlOw0KKwlzdHJ1Y3QgbG9vcF9wZ29mZl9hcnJheSBh
cnJheTsNCisJbG9mZl90IGkgPSAwOw0KKwlzdHJ1Y3QgcmJfbm9kZSAqcmJf
bm9kZSAgPSByYl9maXJzdCgmbG8tPnBnb2ZmX3RyZWUpOw0KKw0KKwlpZiAo
bG8tPmxvX3N0YXRlICE9IExvX2JvdW5kKQ0KKwkJcmV0dXJuIC1FTlhJTzsN
CisNCisJaWYgKGZpbHAgPT0gTlVMTCB8fCAhbG8tPmxvX3RyYWNrX3Bnd3Jp
dGUpDQorCQlyZXR1cm4gLUVJTlZBTDsNCisNCisJaWYgKGNvcHlfZnJvbV91
c2VyKCZhcnJheSwgYXJnLCBzaXplb2YgKHN0cnVjdCBsb29wX3Bnb2ZmX2Fy
cmF5KSkpDQorCQlyZXR1cm4gLUVGQVVMVDsNCisNCisJd2hpbGUgKGkgPCBh
cnJheS5tYXggJiYgcmJfbm9kZSAhPSBOVUxMKSB7DQorDQorCQlpZiAocHV0
X3VzZXIocmJfZW50cnkocmJfbm9kZSwgc3RydWN0IHBnb2ZmX2VsZW0sIG5v
ZGUpLT5vZmZzZXQsDQorCQkJCSAgICAgIGFycmF5LnBnb2ZmICsgaSkpDQor
CQkJcmV0dXJuIC1FRkFVTFQ7DQorDQorCQkrK2k7DQorCQlyYl9ub2RlID0g
cmJfbmV4dChyYl9ub2RlKTsNCisJfQ0KKwlhcnJheS5udW0gPSBpOw0KKw0K
KwlpZiAoY29weV90b191c2VyKGFyZywgJmFycmF5LCBzaXplb2YoYXJyYXkp
KSkNCisJCXJldHVybiAtRUZBVUxUOw0KKw0KKwlyZXR1cm4gMDsNCit9DQog
DQogLyoNCiAgKiBsb29wX2NoYW5nZV9mZCBzd2l0Y2hlZCB0aGUgYmFja2lu
ZyBzdG9yZSBvZiBhIGxvb3BiYWNrIGRldmljZSB0bw0KQEAgLTY5Miw2ICs3
NjAsOCBAQCBzdGF0aWMgaW50IGxvb3BfY2hhbmdlX2ZkKHN0cnVjdCBsb29w
X2RlDQogCWlmIChnZXRfbG9vcF9zaXplKGxvLCBmaWxlKSAhPSBnZXRfbG9v
cF9zaXplKGxvLCBvbGRfZmlsZSkpDQogCQlnb3RvIG91dF9wdXRmOw0KIA0K
KwlwZ29mZl90cmVlX2NsZWFyKCZsby0+cGdvZmZfdHJlZSk7DQorDQogCS8q
IGFuZCAuLi4gc3dpdGNoICovDQogCWVycm9yID0gbG9vcF9zd2l0Y2gobG8s
IGZpbGUpOw0KIAlpZiAoZXJyb3IpDQpAQCAtNzk5LDYgKzg2OSw4IEBAIHN0
YXRpYyBpbnQgbG9vcF9zZXRfZmQoc3RydWN0IGxvb3BfZGV2aWMNCiAJbG8t
PnRyYW5zZmVyID0gdHJhbnNmZXJfbm9uZTsNCiAJbG8tPmlvY3RsID0gTlVM
TDsNCiAJbG8tPmxvX3NpemVsaW1pdCA9IDA7DQorCWxvLT5sb190cmFja19w
Z3dyaXRlID0gMDsNCisJbG8tPnBnb2ZmX3RyZWUgPSBSQl9ST09UOw0KIAls
by0+b2xkX2dmcF9tYXNrID0gbWFwcGluZ19nZnBfbWFzayhtYXBwaW5nKTsN
CiAJbWFwcGluZ19zZXRfZ2ZwX21hc2sobWFwcGluZywgbG8tPm9sZF9nZnBf
bWFzayAmIH4oX19HRlBfSU98X19HRlBfRlMpKTsNCiANCkBAIC05MTMsNiAr
OTg1LDggQEAgc3RhdGljIGludCBsb29wX2Nscl9mZChzdHJ1Y3QgbG9vcF9k
ZXZpYw0KIAlsby0+bG9fc2l6ZWxpbWl0ID0gMDsNCiAJbG8tPmxvX2VuY3J5
cHRfa2V5X3NpemUgPSAwOw0KIAlsby0+bG9fZmxhZ3MgPSAwOw0KKwlsby0+
bG9fdHJhY2tfcGd3cml0ZSA9IDA7DQorCXBnb2ZmX3RyZWVfY2xlYXIoJmxv
LT5wZ29mZl90cmVlKTsNCiAJbG8tPmxvX3RocmVhZCA9IE5VTEw7DQogCW1l
bXNldChsby0+bG9fZW5jcnlwdF9rZXksIDAsIExPX0tFWV9TSVpFKTsNCiAJ
bWVtc2V0KGxvLT5sb19jcnlwdF9uYW1lLCAwLCBMT19OQU1FX1NJWkUpOw0K
QEAgLTk2OSw2ICsxMDQzLDE0IEBAIGxvb3Bfc2V0X3N0YXR1cyhzdHJ1Y3Qg
bG9vcF9kZXZpY2UgKmxvLCANCiAJCQlyZXR1cm4gLUVGQklHOw0KIAl9DQog
DQorCWlmIChpbmZvLT5sb190cmFja19wZ3dyaXRlKQ0KKwkJbG8tPmxvX3Ry
YWNrX3Bnd3JpdGUgPSAxOw0KKwllbHNlIHsNCisJCWlmIChsby0+bG9fdHJh
Y2tfcGd3cml0ZSkNCisJCQlwZ29mZl90cmVlX2NsZWFyKCZsby0+cGdvZmZf
dHJlZSk7DQorCQlsby0+bG9fdHJhY2tfcGd3cml0ZSA9IDA7DQorCX0NCisN
CiAJbWVtY3B5KGxvLT5sb19maWxlX25hbWUsIGluZm8tPmxvX2ZpbGVfbmFt
ZSwgTE9fTkFNRV9TSVpFKTsNCiAJbWVtY3B5KGxvLT5sb19jcnlwdF9uYW1l
LCBpbmZvLT5sb19jcnlwdF9uYW1lLCBMT19OQU1FX1NJWkUpOw0KIAlsby0+
bG9fZmlsZV9uYW1lW0xPX05BTUVfU0laRS0xXSA9IDA7DQpAQCAtMTAxMSw2
ICsxMDkzLDcgQEAgbG9vcF9nZXRfc3RhdHVzKHN0cnVjdCBsb29wX2Rldmlj
ZSAqbG8sIA0KIAlpbmZvLT5sb19vZmZzZXQgPSBsby0+bG9fb2Zmc2V0Ow0K
IAlpbmZvLT5sb19zaXplbGltaXQgPSBsby0+bG9fc2l6ZWxpbWl0Ow0KIAlp
bmZvLT5sb19mbGFncyA9IGxvLT5sb19mbGFnczsNCisJaW5mby0+bG9fdHJh
Y2tfcGd3cml0ZSA9IGxvLT5sb190cmFja19wZ3dyaXRlOw0KIAltZW1jcHko
aW5mby0+bG9fZmlsZV9uYW1lLCBsby0+bG9fZmlsZV9uYW1lLCBMT19OQU1F
X1NJWkUpOw0KIAltZW1jcHkoaW5mby0+bG9fY3J5cHRfbmFtZSwgbG8tPmxv
X2NyeXB0X25hbWUsIExPX05BTUVfU0laRSk7DQogCWluZm8tPmxvX2VuY3J5
cHRfdHlwZSA9DQpAQCAtMTAzNiw2ICsxMTE5LDcgQEAgbG9vcF9pbmZvNjRf
ZnJvbV9vbGQoY29uc3Qgc3RydWN0IGxvb3BfaQ0KIAlpbmZvNjQtPmxvX2Vu
Y3J5cHRfdHlwZSA9IGluZm8tPmxvX2VuY3J5cHRfdHlwZTsNCiAJaW5mbzY0
LT5sb19lbmNyeXB0X2tleV9zaXplID0gaW5mby0+bG9fZW5jcnlwdF9rZXlf
c2l6ZTsNCiAJaW5mbzY0LT5sb19mbGFncyA9IGluZm8tPmxvX2ZsYWdzOw0K
KwlpbmZvNjQtPmxvX3RyYWNrX3Bnd3JpdGUgPSAwOw0KIAlpbmZvNjQtPmxv
X2luaXRbMF0gPSBpbmZvLT5sb19pbml0WzBdOw0KIAlpbmZvNjQtPmxvX2lu
aXRbMV0gPSBpbmZvLT5sb19pbml0WzFdOw0KIAlpZiAoaW5mby0+bG9fZW5j
cnlwdF90eXBlID09IExPX0NSWVBUX0NSWVBUT0FQSSkNCkBAIC0xMTU5LDYg
KzEyNDMsMTIgQEAgc3RhdGljIGludCBsb19pb2N0bChzdHJ1Y3QgaW5vZGUg
KiBpbm9kZQ0KIAljYXNlIExPT1BfR0VUX1NUQVRVUzY0Og0KIAkJZXJyID0g
bG9vcF9nZXRfc3RhdHVzNjQobG8sIChzdHJ1Y3QgbG9vcF9pbmZvNjQgX191
c2VyICopIGFyZyk7DQogCQlicmVhazsNCisJY2FzZSBMT09QX0dFVF9QR1dS
SVRFUzoNCisJCWVyciA9IGxvb3BfZ2V0X3Bnd3JpdGVzKGxvLCAoc3RydWN0
IGxvb3BfcGdvZmZfYXJyYXkgX191c2VyICopIGFyZyk7DQorCQlicmVhazsN
CisJY2FzZSBMT09QX0NMUl9QR1dSSVRFUzoNCisJCWVyciA9IGxvb3BfY2xy
X3Bnd3JpdGVzKGxvKTsNCisJCWJyZWFrOw0KIAlkZWZhdWx0Og0KIAkJZXJy
ID0gbG8tPmlvY3RsID8gbG8tPmlvY3RsKGxvLCBjbWQsIGFyZykgOiAtRUlO
VkFMOw0KIAl9DQpAQCAtMTIwNSw2ICsxMjk1LDcgQEAgbG9vcF9pbmZvNjRf
ZnJvbV9jb21wYXQoY29uc3Qgc3RydWN0IGNvbQ0KIAlpbmZvNjQtPmxvX2Vu
Y3J5cHRfdHlwZSA9IGluZm8ubG9fZW5jcnlwdF90eXBlOw0KIAlpbmZvNjQt
PmxvX2VuY3J5cHRfa2V5X3NpemUgPSBpbmZvLmxvX2VuY3J5cHRfa2V5X3Np
emU7DQogCWluZm82NC0+bG9fZmxhZ3MgPSBpbmZvLmxvX2ZsYWdzOw0KKwlp
bmZvNjQtPmxvX3RyYWNrX3Bnd3JpdGUgPSAwOw0KIAlpbmZvNjQtPmxvX2lu
aXRbMF0gPSBpbmZvLmxvX2luaXRbMF07DQogCWluZm82NC0+bG9faW5pdFsx
XSA9IGluZm8ubG9faW5pdFsxXTsNCiAJaWYgKGluZm8ubG9fZW5jcnlwdF90
eXBlID09IExPX0NSWVBUX0NSWVBUT0FQSSkNCkBAIC0xMzEzLDYgKzE0MDQs
MTAgQEAgc3RhdGljIGxvbmcgbG9fY29tcGF0X2lvY3RsKHN0cnVjdCBmaWxl
IA0KIAljYXNlIExPT1BfQ0hBTkdFX0ZEOg0KIAkJZXJyID0gbG9faW9jdGwo
aW5vZGUsIGZpbGUsIGNtZCwgYXJnKTsNCiAJCWJyZWFrOw0KKwljYXNlIExP
T1BfR0VUX1BHV1JJVEVTOg0KKwljYXNlIExPT1BfQ0xSX1BHV1JJVEVTOg0K
KwkJZXJyID0gLUVJTlZBTDsNCisJCWJyZWFrOw0KIAlkZWZhdWx0Og0KIAkJ
ZXJyID0gLUVOT0lPQ1RMQ01EOw0KIAkJYnJlYWs7DQpAQCAtMTMyMiwxMCAr
MTQxNyw2NyBAQCBzdGF0aWMgbG9uZyBsb19jb21wYXRfaW9jdGwoc3RydWN0
IGZpbGUgDQogfQ0KICNlbmRpZg0KIA0KK3N0YXRpYyBpbnQgcGdvZmZfdHJl
ZV9pbnNlcnQoc3RydWN0IHJiX3Jvb3QgKnJiX3Jvb3QsIHVuc2lnbmVkIGxv
bmcgb2Zmc2V0KQ0KK3sNCisJc3RydWN0IHJiX25vZGUgKipwID0gJnJiX3Jv
b3QtPnJiX25vZGU7DQorCXN0cnVjdCByYl9ub2RlICpwYXJlbnQgPSBOVUxM
Ow0KKwlzdHJ1Y3QgcGdvZmZfZWxlbSAqcGdvZmZfZWxlbTsNCisNCisJd2hp
bGUgKCpwKSB7DQorCQlwYXJlbnQgPSAqcDsNCisJCXBnb2ZmX2VsZW0gPSBy
Yl9lbnRyeShwYXJlbnQsIHN0cnVjdCBwZ29mZl9lbGVtLCBub2RlKTsNCisN
CisJCWlmIChvZmZzZXQgPCBwZ29mZl9lbGVtLT5vZmZzZXQpDQorCQkJcCA9
ICYoKnApLT5yYl9sZWZ0Ow0KKwkJZWxzZSBpZiAob2Zmc2V0ID4gcGdvZmZf
ZWxlbS0+b2Zmc2V0KQ0KKwkJCXAgPSAmKCpwKS0+cmJfcmlnaHQ7DQorCQll
bHNlDQorCQkJcmV0dXJuIDA7DQorCX0NCisNCisJcGdvZmZfZWxlbSA9IGtt
ZW1fY2FjaGVfYWxsb2MocGdvZmZfZWxlbV9jYWNoZSwgR0ZQX0tFUk5FTCk7
DQorCWlmICghcGdvZmZfZWxlbSkNCisJCXJldHVybiAtRU5PTUVNOw0KKwlw
Z29mZl9lbGVtLT5vZmZzZXQgPSBvZmZzZXQ7DQorDQorCXJiX2xpbmtfbm9k
ZSgmcGdvZmZfZWxlbS0+bm9kZSwgcGFyZW50LCBwKTsNCisJcmJfaW5zZXJ0
X2NvbG9yKCZwZ29mZl9lbGVtLT5ub2RlLCByYl9yb290KTsNCisNCisJcmV0
dXJuIDA7DQorfQ0KKw0KK3N0YXRpYyBpbnQgbG9vcF90cmFja19wZ3dyaXRl
cyhzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwgc3RydWN0IHBhZ2UgKnBh
Z2UpDQorew0KKwlzdHJ1Y3QgZmlsZSAqZmlsZSA9IHZtYS0+dm1fZmlsZTsN
CisJc3RydWN0IGlub2RlICppbm9kZSA9IGZpbGUtPmZfZGVudHJ5LT5kX2lu
b2RlOw0KKwlzdHJ1Y3QgbG9vcF9kZXZpY2UgKmxvID0gaW5vZGUtPmlfYmRl
di0+YmRfZGlzay0+cHJpdmF0ZV9kYXRhOw0KKw0KKwlyZXR1cm4gcGdvZmZf
dHJlZV9pbnNlcnQoJmxvLT5wZ29mZl90cmVlLCBwYWdlLT5pbmRleCk7DQor
fQ0KKw0KK3N0cnVjdCB2bV9vcGVyYXRpb25zX3N0cnVjdCBsb29wX2ZpbGVf
dm1fb3BzID0gew0KKwkubm9wYWdlCQk9IGZpbGVtYXBfbm9wYWdlLA0KKwku
cG9wdWxhdGUJPSBmaWxlbWFwX3BvcHVsYXRlLA0KKwkucGFnZV9ta3dyaXRl
ID0gbG9vcF90cmFja19wZ3dyaXRlcw0KK307DQorDQorc3RhdGljIGludCBs
b29wX2ZpbGVfbW1hcChzdHJ1Y3QgZmlsZSAqIGZpbGUsIHN0cnVjdCB2bV9h
cmVhX3N0cnVjdCAqIHZtYSkNCit7DQorCS8qIFRoaXMgaXMgdXNlZCBmb3Ig
YSBnZW5lcmFsIG1tYXAgb2YgYSBkaXNrIGZpbGUgKi8NCisJaW50IGVyciA9
IGdlbmVyaWNfZmlsZV9tbWFwKGZpbGUsIHZtYSk7DQorDQorCWlmIChlcnIp
DQorCQlyZXR1cm4gZXJyOw0KKw0KKwl2bWEtPnZtX29wcyA9ICZsb29wX2Zp
bGVfdm1fb3BzOw0KKwlyZXR1cm4gMDsNCit9DQorDQogc3RhdGljIGludCBs
b19vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxl
KQ0KIHsNCiAJc3RydWN0IGxvb3BfZGV2aWNlICpsbyA9IGlub2RlLT5pX2Jk
ZXYtPmJkX2Rpc2stPnByaXZhdGVfZGF0YTsNCiANCisJZmlsZS0+Zl9vcCA9
ICZsb29wX2ZvcHM7DQogCW11dGV4X2xvY2soJmxvLT5sb19jdGxfbXV0ZXgp
Ow0KIAlsby0+bG9fcmVmY250Kys7DQogCW11dGV4X3VubG9jaygmbG8tPmxv
X2N0bF9tdXRleCk7DQpAQCAtMTM5OCwxMCArMTU1MCwyNCBAQCBpbnQgbG9v
cF91bnJlZ2lzdGVyX3RyYW5zZmVyKGludCBudW1iZXIpDQogRVhQT1JUX1NZ
TUJPTChsb29wX3JlZ2lzdGVyX3RyYW5zZmVyKTsNCiBFWFBPUlRfU1lNQk9M
KGxvb3BfdW5yZWdpc3Rlcl90cmFuc2Zlcik7DQogDQorc3RhdGljIGNvbnN0
IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgKmdldF9kZWZfYmxrX2ZvcHModm9p
ZCkNCit7DQorCXN0cnVjdCBpbm9kZSBpbm9kZTsNCisNCisJLyogYSByb3Vu
ZGFib3V0IHdheSB0byByZXRyaWV2ZSBkZWZfYmxrX2ZvcHMgYnV0IGF2b2lk
cyB1bmRlZmluZWQNCisJICogcmVmZXJlbmNlIHdhcm5pbmcgKi8NCisJaW5p
dF9zcGVjaWFsX2lub2RlKCZpbm9kZSwgU19JRkJMSywgMCk7DQorDQorCXJl
dHVybiBpbm9kZS5pX2ZvcDsNCit9DQorDQogc3RhdGljIGludCBfX2luaXQg
bG9vcF9pbml0KHZvaWQpDQogew0KIAlpbnQJaTsNCiANCisJbG9vcF9mb3Bz
ID0gKihnZXRfZGVmX2Jsa19mb3BzKCkpOw0KKwlsb29wX2ZvcHMubW1hcCA9
IGxvb3BfZmlsZV9tbWFwOw0KKw0KIAlpZiAobWF4X2xvb3AgPCAxIHx8IG1h
eF9sb29wID4gMjU2KSB7DQogCQlwcmludGsoS0VSTl9XQVJOSU5HICJsb29w
OiBpbnZhbGlkIG1heF9sb29wIChtdXN0IGJlIGJldHdlZW4iDQogCQkJCSAg
ICAiIDEgYW5kIDI1NiksIHVzaW5nIGRlZmF1bHQgKDgpXG4iKTsNCkBAIC0x
NDExLDYgKzE1NzcsMTIgQEAgc3RhdGljIGludCBfX2luaXQgbG9vcF9pbml0
KHZvaWQpDQogCWlmIChyZWdpc3Rlcl9ibGtkZXYoTE9PUF9NQUpPUiwgImxv
b3AiKSkNCiAJCXJldHVybiAtRUlPOw0KIA0KKwlwZ29mZl9lbGVtX2NhY2hl
ID0ga21lbV9jYWNoZV9jcmVhdGUoY2FjaGVfbmFtZSwNCisJCQkJCSAgICAg
c2l6ZW9mKHN0cnVjdCBwZ29mZl9lbGVtKSwgMCwNCisJCQkJCSAgICAgU0xB
Ql9IV0NBQ0hFX0FMSUdOLCBOVUxMLCBOVUxMKTsNCisJaWYgKCFwZ29mZl9l
bGVtX2NhY2hlKQ0KKwkJZ290byBvdXRfbWVtMDsNCisNCiAJbG9vcF9kZXYg
PSBrbWFsbG9jKG1heF9sb29wICogc2l6ZW9mKHN0cnVjdCBsb29wX2Rldmlj
ZSksIEdGUF9LRVJORUwpOw0KIAlpZiAoIWxvb3BfZGV2KQ0KIAkJZ290byBv
dXRfbWVtMTsNCkBAIC0xNDY0LDYgKzE2MzYsOCBAQCBvdXRfbWVtMzoNCiBv
dXRfbWVtMjoNCiAJa2ZyZWUobG9vcF9kZXYpOw0KIG91dF9tZW0xOg0KKwlr
bWVtX2NhY2hlX2Rlc3Ryb3kocGdvZmZfZWxlbV9jYWNoZSk7DQorb3V0X21l
bTA6DQogCXVucmVnaXN0ZXJfYmxrZGV2KExPT1BfTUFKT1IsICJsb29wIik7
DQogCXByaW50ayhLRVJOX0VSUiAibG9vcDogcmFuIG91dCBvZiBtZW1vcnlc
biIpOw0KIAlyZXR1cm4gLUVOT01FTTsNCkBAIC0xNDgzLDYgKzE2NTcsNyBA
QCBzdGF0aWMgdm9pZCBsb29wX2V4aXQodm9pZCkNCiANCiAJa2ZyZWUoZGlz
a3MpOw0KIAlrZnJlZShsb29wX2Rldik7DQorCWttZW1fY2FjaGVfZGVzdHJv
eShwZ29mZl9lbGVtX2NhY2hlKTsNCiB9DQogDQogbW9kdWxlX2luaXQobG9v
cF9pbml0KTsNCmRpZmYgLXVwck4gbGludXgtMi42LjE5LjIvaW5jbHVkZS9s
aW51eC9sb29wLmggbGludXgtMi42LjE5LjItbmV3L2luY2x1ZGUvbGludXgv
bG9vcC5oDQotLS0gbGludXgtMi42LjE5LjIvaW5jbHVkZS9saW51eC9sb29w
LmgJMjAwNy0wMy0wMyAxNjoyNTo0Mi4wMDAwMDAwMDAgKzExMDANCisrKyBs
aW51eC0yLjYuMTkuMi1uZXcvaW5jbHVkZS9saW51eC9sb29wLmgJMjAwNy0w
My0wMyAxNjo0Mzo0OS4wMDAwMDAwMDAgKzExMDANCkBAIC0xOCw2ICsxOCw3
IEBADQogI2luY2x1ZGUgPGxpbnV4L2Jsa2Rldi5oPg0KICNpbmNsdWRlIDxs
aW51eC9zcGlubG9jay5oPg0KICNpbmNsdWRlIDxsaW51eC9tdXRleC5oPg0K
KyNpbmNsdWRlIDxsaW51eC9yYnRyZWUuaD4NCiANCiAvKiBQb3NzaWJsZSBz
dGF0ZXMgb2YgZGV2aWNlICovDQogZW51bSB7DQpAQCAtMzQsNiArMzUsOCBA
QCBzdHJ1Y3QgbG9vcF9kZXZpY2Ugew0KIAlsb2ZmX3QJCWxvX29mZnNldDsN
CiAJbG9mZl90CQlsb19zaXplbGltaXQ7DQogCWludAkJbG9fZmxhZ3M7DQor
CWludAkJbG9fdHJhY2tfcGd3cml0ZTsNCisJc3RydWN0IHJiX3Jvb3QJcGdv
ZmZfdHJlZTsNCiAJaW50CQkoKnRyYW5zZmVyKShzdHJ1Y3QgbG9vcF9kZXZp
Y2UgKiwgaW50IGNtZCwNCiAJCQkJICAgIHN0cnVjdCBwYWdlICpyYXdfcGFn
ZSwgdW5zaWduZWQgcmF3X29mZiwNCiAJCQkJICAgIHN0cnVjdCBwYWdlICps
b29wX3BhZ2UsIHVuc2lnbmVkIGxvb3Bfb2ZmLA0KQEAgLTY2LDYgKzY5LDEx
IEBAIHN0cnVjdCBsb29wX2RldmljZSB7DQogCXJlcXVlc3RfcXVldWVfdAkJ
KmxvX3F1ZXVlOw0KIH07DQogDQorc3RydWN0IHBnb2ZmX2VsZW0gew0KKwlz
dHJ1Y3QgcmJfbm9kZQkJbm9kZTsNCisJdW5zaWduZWQgbG9uZwkJb2Zmc2V0
Ow0KK307DQorDQogI2VuZGlmIC8qIF9fS0VSTkVMX18gKi8NCiANCiAvKg0K
QEAgLTEwNSwxMiArMTEzLDIwIEBAIHN0cnVjdCBsb29wX2luZm82NCB7DQog
CV9fdTMyCQkgICBsb19lbmNyeXB0X3R5cGU7DQogCV9fdTMyCQkgICBsb19l
bmNyeXB0X2tleV9zaXplOwkJLyogaW9jdGwgdy9vICovDQogCV9fdTMyCQkg
ICBsb19mbGFnczsJCQkvKiBpb2N0bCByL28gKi8NCisJX191MzIJCSAgIGxv
X3RyYWNrX3Bnd3JpdGU7DQogCV9fdTgJCSAgIGxvX2ZpbGVfbmFtZVtMT19O
QU1FX1NJWkVdOw0KIAlfX3U4CQkgICBsb19jcnlwdF9uYW1lW0xPX05BTUVf
U0laRV07DQogCV9fdTgJCSAgIGxvX2VuY3J5cHRfa2V5W0xPX0tFWV9TSVpF
XTsgLyogaW9jdGwgdy9vICovDQogCV9fdTY0CQkgICBsb19pbml0WzJdOw0K
IH07DQogDQorc3RydWN0IGxvb3BfcGdvZmZfYXJyYXkgew0KKwlfX3U2NCBt
YXg7CS8qIHNpemUgb2YgYXJyYXkgcGFzc2VkIGJ5IHVzZXIgKi8NCisJX191
NjQgbnVtOwkvKiBudW1iZXIgb2YgZW50cmllcyBmaWxsZWQgaW4gYnkgZHJp
dmVyICovDQorCV9fdTY0ICpwZ29mZjsJLyogYXJyYXkgb2YgcGFnZSBvZmZz
ZXRzIG9mIHBhZ2VzIHdyaXR0ZW4gdG8gYnkgbW1hcCAqLw0KK307DQorDQor
DQogLyoNCiAgKiBMb29wIGZpbHRlciB0eXBlcw0KICAqLw0KQEAgLTE1Nyw1
ICsxNzMsNyBAQCBpbnQgbG9vcF91bnJlZ2lzdGVyX3RyYW5zZmVyKGludCBu
dW1iZXIpDQogI2RlZmluZSBMT09QX1NFVF9TVEFUVVM2NAkweDRDMDQNCiAj
ZGVmaW5lIExPT1BfR0VUX1NUQVRVUzY0CTB4NEMwNQ0KICNkZWZpbmUgTE9P
UF9DSEFOR0VfRkQJCTB4NEMwNg0KKyNkZWZpbmUgTE9PUF9HRVRfUEdXUklU
RVMJMHg0QzA3DQorI2RlZmluZSBMT09QX0NMUl9QR1dSSVRFUwkweDRDMDgN
CiANCiAjZW5kaWYNCg==

--1585517810-124106876-1173322907=:21734--
