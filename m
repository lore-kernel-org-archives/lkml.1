Return-Path: <linux-kernel-owner+w=401wt.eu-S933213AbXCMUVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbXCMUVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933215AbXCMUVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:21:54 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:54863 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933213AbXCMUVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:21:53 -0400
From: Kandan Venkataraman <kven709@cse.unsw.EDU.AU>
To: linux-kernel@vger.kernel.org
Date: Wed, 14 Mar 2007 07:21:41 +1100 (EST)
X-X-Sender: kven709@williams.orchestra.cse.unsw.EDU.AU
cc: akpm@linux-foundation.org
Subject: [PATCH] Loop device - Tracking page writes made to a loop device
 through mmap
Message-ID: <Pine.LNX.4.64.0703140712080.18655@williams.orchestra.cse.unsw.EDU.AU>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1585517810-570499139-1173817301=:18655"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1585517810-570499139-1173817301=:18655
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
is being written to, in a red-black tree within the loop device.

A flag lo_track_pgwrite has been added to the struct loop_device to turn
on/off tracking of page writes.

Three new ioctls have been added.

The ioctl cmd LOOP_SET_TRACK_PGWRITE sets/unsets the flag lo_track_pgwrite
in the struct loop_device.
The ioctl cmd LOOP_GET_PGWRITES retrieves the page offsets of pages that
have been written to.
The ioctl cmd LOOP_CLR_PGWRITES empties the red-black tree.

The existing interface has been left untouched. Thus applications such as 
losetup would work as is.

The functionality added would allow us to have a read only version and a 
write version of memory by doing the following:
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


        if (ioctl(fd, LOOP_SET_TRACK_PGWRITE, 1) < 0) {
                perror("ioctl: LOOP_SET_TRACK_PGWRITE");
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



--1585517810-570499139-1173817301=:18655
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=patch2
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0703140721410.18655@williams.orchestra.cse.unsw.EDU.AU>
Content-Description: 
Content-Disposition: attachment; filename=patch2

ZGlmZiAtdXByTiBsaW51eC0yLjYuMTkuMi9kcml2ZXJzL2Jsb2NrL2xvb3Au
YyBsaW51eC0yLjYuMTkuMi1uZXcvZHJpdmVycy9ibG9jay9sb29wLmMNCi0t
LSBsaW51eC0yLjYuMTkuMi9kcml2ZXJzL2Jsb2NrL2xvb3AuYwkyMDA3LTAx
LTExIDA2OjEwOjM3LjAwMDAwMDAwMCArMTEwMA0KKysrIGxpbnV4LTIuNi4x
OS4yLW5ldy9kcml2ZXJzL2Jsb2NrL2xvb3AuYwkyMDA3LTAzLTExIDA3OjMx
OjI2LjAwMDAwMDAwMCArMTEwMA0KQEAgLTc0LDEyICs3NCwxNiBAQA0KICNp
bmNsdWRlIDxsaW51eC9oaWdobWVtLmg+DQogI2luY2x1ZGUgPGxpbnV4L2dm
cC5oPg0KICNpbmNsdWRlIDxsaW51eC9rdGhyZWFkLmg+DQorI2luY2x1ZGUg
PGxpbnV4L21tLmg+DQogDQogI2luY2x1ZGUgPGFzbS91YWNjZXNzLmg+DQog
DQogc3RhdGljIGludCBtYXhfbG9vcCA9IDg7DQogc3RhdGljIHN0cnVjdCBs
b29wX2RldmljZSAqbG9vcF9kZXY7DQogc3RhdGljIHN0cnVjdCBnZW5kaXNr
ICoqZGlza3M7DQorc3RhdGljIGttZW1fY2FjaGVfdCAqcGdvZmZfZWxlbV9j
YWNoZTsNCitzdGF0aWMgY2hhciAqY2FjaGVfbmFtZSA9ICJsb29wX3Bnb2Zm
X2VsZW1fY2FjaGUiOw0KK3N0YXRpYyBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25z
IGxvb3BfZm9wczsNCiANCiAvKg0KICAqIFRyYW5zZmVyIGZ1bmN0aW9ucw0K
QEAgLTY0Niw2ICs2NTAsODUgQEAgc3RhdGljIHZvaWQgZG9fbG9vcF9zd2l0
Y2goc3RydWN0IGxvb3BfZA0KIAljb21wbGV0ZSgmcC0+d2FpdCk7DQogfQ0K
IA0KK3N0YXRpYyB2b2lkIHBnb2ZmX3RyZWVfY2xlYXIoc3RydWN0IHJiX3Jv
b3QgKnJiX3Jvb3QpDQorew0KKwlzdHJ1Y3QgcmJfbm9kZSAqcmJfbm9kZSAg
PSByYl9yb290LT5yYl9ub2RlOw0KKw0KKwl3aGlsZSAocmJfbm9kZSAhPSBO
VUxMKSB7DQorDQorCQlyYl9lcmFzZShyYl9ub2RlLCByYl9yb290KTsNCisJ
CWttZW1fY2FjaGVfZnJlZShwZ29mZl9lbGVtX2NhY2hlLCByYl9lbnRyeShy
Yl9ub2RlLCANCisJCQkJc3RydWN0IHBnb2ZmX2VsZW0sIG5vZGUpKTsNCisJ
CXJiX25vZGUgPSByYl9yb290LT5yYl9ub2RlOw0KKwl9DQorDQorCSpyYl9y
b290ID0gUkJfUk9PVDsNCit9DQorDQorc3RhdGljIGludCBsb29wX3NldF90
cmFja19wZ3dyaXRlKHN0cnVjdCBsb29wX2RldmljZSAqbG8sIHVuc2lnbmVk
IGxvbmcgYXJnKQ0KK3sNCisJaWYgKGxvLT5sb19zdGF0ZSAhPSBMb19ib3Vu
ZCkNCisJCXJldHVybiAtRU5YSU87DQorDQorCWlmIChhcmcpDQorCQlsby0+
bG9fdHJhY2tfcGd3cml0ZSA9IDE7DQorCWVsc2Ugew0KKwkJaWYgKGxvLT5s
b190cmFja19wZ3dyaXRlKQ0KKwkJCXBnb2ZmX3RyZWVfY2xlYXIoJmxvLT5w
Z29mZl90cmVlKTsNCisJCWxvLT5sb190cmFja19wZ3dyaXRlID0gMDsNCisJ
fQ0KKw0KKwlyZXR1cm4gMDsNCit9DQorDQorc3RhdGljIGludCBsb29wX2Ns
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
NzUsOCBAQCBzdGF0aWMgaW50IGxvb3BfY2hhbmdlX2ZkKHN0cnVjdCBsb29w
X2RlDQogCWlmIChnZXRfbG9vcF9zaXplKGxvLCBmaWxlKSAhPSBnZXRfbG9v
cF9zaXplKGxvLCBvbGRfZmlsZSkpDQogCQlnb3RvIG91dF9wdXRmOw0KIA0K
KwlwZ29mZl90cmVlX2NsZWFyKCZsby0+cGdvZmZfdHJlZSk7DQorDQogCS8q
IGFuZCAuLi4gc3dpdGNoICovDQogCWVycm9yID0gbG9vcF9zd2l0Y2gobG8s
IGZpbGUpOw0KIAlpZiAoZXJyb3IpDQpAQCAtNzk5LDYgKzg4NCw4IEBAIHN0
YXRpYyBpbnQgbG9vcF9zZXRfZmQoc3RydWN0IGxvb3BfZGV2aWMNCiAJbG8t
PnRyYW5zZmVyID0gdHJhbnNmZXJfbm9uZTsNCiAJbG8tPmlvY3RsID0gTlVM
TDsNCiAJbG8tPmxvX3NpemVsaW1pdCA9IDA7DQorCWxvLT5sb190cmFja19w
Z3dyaXRlID0gMDsNCisJbG8tPnBnb2ZmX3RyZWUgPSBSQl9ST09UOw0KIAls
by0+b2xkX2dmcF9tYXNrID0gbWFwcGluZ19nZnBfbWFzayhtYXBwaW5nKTsN
CiAJbWFwcGluZ19zZXRfZ2ZwX21hc2sobWFwcGluZywgbG8tPm9sZF9nZnBf
bWFzayAmIH4oX19HRlBfSU98X19HRlBfRlMpKTsNCiANCkBAIC05MTMsNiAr
MTAwMCw4IEBAIHN0YXRpYyBpbnQgbG9vcF9jbHJfZmQoc3RydWN0IGxvb3Bf
ZGV2aWMNCiAJbG8tPmxvX3NpemVsaW1pdCA9IDA7DQogCWxvLT5sb19lbmNy
eXB0X2tleV9zaXplID0gMDsNCiAJbG8tPmxvX2ZsYWdzID0gMDsNCisJbG8t
PmxvX3RyYWNrX3Bnd3JpdGUgPSAwOw0KKwlwZ29mZl90cmVlX2NsZWFyKCZs
by0+cGdvZmZfdHJlZSk7DQogCWxvLT5sb190aHJlYWQgPSBOVUxMOw0KIAlt
ZW1zZXQobG8tPmxvX2VuY3J5cHRfa2V5LCAwLCBMT19LRVlfU0laRSk7DQog
CW1lbXNldChsby0+bG9fY3J5cHRfbmFtZSwgMCwgTE9fTkFNRV9TSVpFKTsN
CkBAIC0xMTU5LDYgKzEyNDgsMTUgQEAgc3RhdGljIGludCBsb19pb2N0bChz
dHJ1Y3QgaW5vZGUgKiBpbm9kZQ0KIAljYXNlIExPT1BfR0VUX1NUQVRVUzY0
Og0KIAkJZXJyID0gbG9vcF9nZXRfc3RhdHVzNjQobG8sIChzdHJ1Y3QgbG9v
cF9pbmZvNjQgX191c2VyICopIGFyZyk7DQogCQlicmVhazsNCisJY2FzZSBM
T09QX1NFVF9UUkFDS19QR1dSSVRFOg0KKwkJZXJyID0gbG9vcF9zZXRfdHJh
Y2tfcGd3cml0ZShsbywgYXJnKTsNCisJCWJyZWFrOw0KKwljYXNlIExPT1Bf
R0VUX1BHV1JJVEVTOg0KKwkJZXJyID0gbG9vcF9nZXRfcGd3cml0ZXMobG8s
IChzdHJ1Y3QgbG9vcF9wZ29mZl9hcnJheSBfX3VzZXIgKikgYXJnKTsNCisJ
CWJyZWFrOw0KKwljYXNlIExPT1BfQ0xSX1BHV1JJVEVTOg0KKwkJZXJyID0g
bG9vcF9jbHJfcGd3cml0ZXMobG8pOw0KKwkJYnJlYWs7DQogCWRlZmF1bHQ6
DQogCQllcnIgPSBsby0+aW9jdGwgPyBsby0+aW9jdGwobG8sIGNtZCwgYXJn
KSA6IC1FSU5WQUw7DQogCX0NCkBAIC0xMzIyLDEwICsxNDIwLDY3IEBAIHN0
YXRpYyBsb25nIGxvX2NvbXBhdF9pb2N0bChzdHJ1Y3QgZmlsZSANCiB9DQog
I2VuZGlmDQogDQorc3RhdGljIGludCBwZ29mZl90cmVlX2luc2VydChzdHJ1
Y3QgcmJfcm9vdCAqcmJfcm9vdCwgdW5zaWduZWQgbG9uZyBvZmZzZXQpDQor
ew0KKwlzdHJ1Y3QgcmJfbm9kZSAqKnAgPSAmcmJfcm9vdC0+cmJfbm9kZTsN
CisJc3RydWN0IHJiX25vZGUgKnBhcmVudCA9IE5VTEw7DQorCXN0cnVjdCBw
Z29mZl9lbGVtICpwZ29mZl9lbGVtOw0KKw0KKwl3aGlsZSAoKnApIHsNCisJ
CXBhcmVudCA9ICpwOw0KKwkJcGdvZmZfZWxlbSA9IHJiX2VudHJ5KHBhcmVu
dCwgc3RydWN0IHBnb2ZmX2VsZW0sIG5vZGUpOw0KKw0KKwkJaWYgKG9mZnNl
dCA8IHBnb2ZmX2VsZW0tPm9mZnNldCkNCisJCQlwID0gJigqcCktPnJiX2xl
ZnQ7DQorCQllbHNlIGlmIChvZmZzZXQgPiBwZ29mZl9lbGVtLT5vZmZzZXQp
DQorCQkJcCA9ICYoKnApLT5yYl9yaWdodDsNCisJCWVsc2UNCisJCQlyZXR1
cm4gMDsNCisJfQ0KKw0KKwlwZ29mZl9lbGVtID0ga21lbV9jYWNoZV9hbGxv
YyhwZ29mZl9lbGVtX2NhY2hlLCBHRlBfS0VSTkVMKTsNCisJaWYgKCFwZ29m
Zl9lbGVtKQ0KKwkJcmV0dXJuIC1FTk9NRU07DQorCXBnb2ZmX2VsZW0tPm9m
ZnNldCA9IG9mZnNldDsNCisNCisJcmJfbGlua19ub2RlKCZwZ29mZl9lbGVt
LT5ub2RlLCBwYXJlbnQsIHApOw0KKwlyYl9pbnNlcnRfY29sb3IoJnBnb2Zm
X2VsZW0tPm5vZGUsIHJiX3Jvb3QpOw0KKw0KKwlyZXR1cm4gMDsNCit9DQor
DQorc3RhdGljIGludCBsb29wX3RyYWNrX3Bnd3JpdGVzKHN0cnVjdCB2bV9h
cmVhX3N0cnVjdCAqdm1hLCBzdHJ1Y3QgcGFnZSAqcGFnZSkNCit7DQorCXN0
cnVjdCBmaWxlICpmaWxlID0gdm1hLT52bV9maWxlOw0KKwlzdHJ1Y3QgaW5v
ZGUgKmlub2RlID0gZmlsZS0+Zl9kZW50cnktPmRfaW5vZGU7DQorCXN0cnVj
dCBsb29wX2RldmljZSAqbG8gPSBpbm9kZS0+aV9iZGV2LT5iZF9kaXNrLT5w
cml2YXRlX2RhdGE7DQorDQorCXJldHVybiBwZ29mZl90cmVlX2luc2VydCgm
bG8tPnBnb2ZmX3RyZWUsIHBhZ2UtPmluZGV4KTsNCit9DQorDQorc3RydWN0
IHZtX29wZXJhdGlvbnNfc3RydWN0IGxvb3BfZmlsZV92bV9vcHMgPSB7DQor
CS5ub3BhZ2UJCT0gZmlsZW1hcF9ub3BhZ2UsDQorCS5wb3B1bGF0ZQk9IGZp
bGVtYXBfcG9wdWxhdGUsDQorCS5wYWdlX21rd3JpdGUgPSBsb29wX3RyYWNr
X3Bnd3JpdGVzDQorfTsNCisNCitzdGF0aWMgaW50IGxvb3BfZmlsZV9tbWFw
KHN0cnVjdCBmaWxlICogZmlsZSwgc3RydWN0IHZtX2FyZWFfc3RydWN0ICog
dm1hKQ0KK3sNCisJLyogVGhpcyBpcyB1c2VkIGZvciBhIGdlbmVyYWwgbW1h
cCBvZiBhIGRpc2sgZmlsZSAqLw0KKwlpbnQgZXJyID0gZ2VuZXJpY19maWxl
X21tYXAoZmlsZSwgdm1hKTsNCisNCisJaWYgKGVycikNCisJCXJldHVybiBl
cnI7DQorDQorCXZtYS0+dm1fb3BzID0gJmxvb3BfZmlsZV92bV9vcHM7DQor
CXJldHVybiAwOw0KK30NCisNCiBzdGF0aWMgaW50IGxvX29wZW4oc3RydWN0
IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpDQogew0KIAlzdHJ1
Y3QgbG9vcF9kZXZpY2UgKmxvID0gaW5vZGUtPmlfYmRldi0+YmRfZGlzay0+
cHJpdmF0ZV9kYXRhOw0KIA0KKwlmaWxlLT5mX29wID0gJmxvb3BfZm9wczsN
CiAJbXV0ZXhfbG9jaygmbG8tPmxvX2N0bF9tdXRleCk7DQogCWxvLT5sb19y
ZWZjbnQrKzsNCiAJbXV0ZXhfdW5sb2NrKCZsby0+bG9fY3RsX211dGV4KTsN
CkBAIC0xMzk4LDEwICsxNTUzLDI0IEBAIGludCBsb29wX3VucmVnaXN0ZXJf
dHJhbnNmZXIoaW50IG51bWJlcikNCiBFWFBPUlRfU1lNQk9MKGxvb3BfcmVn
aXN0ZXJfdHJhbnNmZXIpOw0KIEVYUE9SVF9TWU1CT0wobG9vcF91bnJlZ2lz
dGVyX3RyYW5zZmVyKTsNCiANCitzdGF0aWMgY29uc3Qgc3RydWN0IGZpbGVf
b3BlcmF0aW9ucyAqZ2V0X2RlZl9ibGtfZm9wcyh2b2lkKQ0KK3sNCisJc3Ry
dWN0IGlub2RlIGlub2RlOw0KKw0KKwkvKiBhIHJvdW5kYWJvdXQgd2F5IHRv
IHJldHJpZXZlIGRlZl9ibGtfZm9wcyBidXQgYXZvaWRzIHVuZGVmaW5lZA0K
KwkgKiByZWZlcmVuY2Ugd2FybmluZyAqLw0KKwlpbml0X3NwZWNpYWxfaW5v
ZGUoJmlub2RlLCBTX0lGQkxLLCAwKTsNCisNCisJcmV0dXJuIGlub2RlLmlf
Zm9wOw0KK30NCisNCiBzdGF0aWMgaW50IF9faW5pdCBsb29wX2luaXQodm9p
ZCkNCiB7DQogCWludAlpOw0KIA0KKwlsb29wX2ZvcHMgPSAqKGdldF9kZWZf
YmxrX2ZvcHMoKSk7DQorCWxvb3BfZm9wcy5tbWFwID0gbG9vcF9maWxlX21t
YXA7DQorDQogCWlmIChtYXhfbG9vcCA8IDEgfHwgbWF4X2xvb3AgPiAyNTYp
IHsNCiAJCXByaW50ayhLRVJOX1dBUk5JTkcgImxvb3A6IGludmFsaWQgbWF4
X2xvb3AgKG11c3QgYmUgYmV0d2VlbiINCiAJCQkJICAgICIgMSBhbmQgMjU2
KSwgdXNpbmcgZGVmYXVsdCAoOClcbiIpOw0KQEAgLTE0MTEsNiArMTU4MCwx
MiBAQCBzdGF0aWMgaW50IF9faW5pdCBsb29wX2luaXQodm9pZCkNCiAJaWYg
KHJlZ2lzdGVyX2Jsa2RldihMT09QX01BSk9SLCAibG9vcCIpKQ0KIAkJcmV0
dXJuIC1FSU87DQogDQorCXBnb2ZmX2VsZW1fY2FjaGUgPSBrbWVtX2NhY2hl
X2NyZWF0ZShjYWNoZV9uYW1lLA0KKwkJCQkJICAgICBzaXplb2Yoc3RydWN0
IHBnb2ZmX2VsZW0pLCAwLA0KKwkJCQkJICAgICBTTEFCX0hXQ0FDSEVfQUxJ
R04sIE5VTEwsIE5VTEwpOw0KKwlpZiAoIXBnb2ZmX2VsZW1fY2FjaGUpDQor
CQlnb3RvIG91dF9tZW0wOw0KKw0KIAlsb29wX2RldiA9IGttYWxsb2MobWF4
X2xvb3AgKiBzaXplb2Yoc3RydWN0IGxvb3BfZGV2aWNlKSwgR0ZQX0tFUk5F
TCk7DQogCWlmICghbG9vcF9kZXYpDQogCQlnb3RvIG91dF9tZW0xOw0KQEAg
LTE0NjQsNiArMTYzOSw4IEBAIG91dF9tZW0zOg0KIG91dF9tZW0yOg0KIAlr
ZnJlZShsb29wX2Rldik7DQogb3V0X21lbTE6DQorCWttZW1fY2FjaGVfZGVz
dHJveShwZ29mZl9lbGVtX2NhY2hlKTsNCitvdXRfbWVtMDoNCiAJdW5yZWdp
c3Rlcl9ibGtkZXYoTE9PUF9NQUpPUiwgImxvb3AiKTsNCiAJcHJpbnRrKEtF
Uk5fRVJSICJsb29wOiByYW4gb3V0IG9mIG1lbW9yeVxuIik7DQogCXJldHVy
biAtRU5PTUVNOw0KQEAgLTE0ODMsNiArMTY2MCw3IEBAIHN0YXRpYyB2b2lk
IGxvb3BfZXhpdCh2b2lkKQ0KIA0KIAlrZnJlZShkaXNrcyk7DQogCWtmcmVl
KGxvb3BfZGV2KTsNCisJa21lbV9jYWNoZV9kZXN0cm95KHBnb2ZmX2VsZW1f
Y2FjaGUpOw0KIH0NCiANCiBtb2R1bGVfaW5pdChsb29wX2luaXQpOw0KZGlm
ZiAtdXByTiBsaW51eC0yLjYuMTkuMi9pbmNsdWRlL2xpbnV4L2xvb3AuaCBs
aW51eC0yLjYuMTkuMi1uZXcvaW5jbHVkZS9saW51eC9sb29wLmgNCi0tLSBs
aW51eC0yLjYuMTkuMi9pbmNsdWRlL2xpbnV4L2xvb3AuaAkyMDA3LTAxLTEx
IDA2OjEwOjM3LjAwMDAwMDAwMCArMTEwMA0KKysrIGxpbnV4LTIuNi4xOS4y
LW5ldy9pbmNsdWRlL2xpbnV4L2xvb3AuaAkyMDA3LTAzLTExIDA3OjMxOjQx
LjAwMDAwMDAwMCArMTEwMA0KQEAgLTE4LDYgKzE4LDcgQEANCiAjaW5jbHVk
ZSA8bGludXgvYmxrZGV2Lmg+DQogI2luY2x1ZGUgPGxpbnV4L3NwaW5sb2Nr
Lmg+DQogI2luY2x1ZGUgPGxpbnV4L211dGV4Lmg+DQorI2luY2x1ZGUgPGxp
bnV4L3JidHJlZS5oPg0KIA0KIC8qIFBvc3NpYmxlIHN0YXRlcyBvZiBkZXZp
Y2UgKi8NCiBlbnVtIHsNCkBAIC0zNCw2ICszNSw4IEBAIHN0cnVjdCBsb29w
X2RldmljZSB7DQogCWxvZmZfdAkJbG9fb2Zmc2V0Ow0KIAlsb2ZmX3QJCWxv
X3NpemVsaW1pdDsNCiAJaW50CQlsb19mbGFnczsNCisJaW50CQlsb190cmFj
a19wZ3dyaXRlOw0KKwlzdHJ1Y3QgcmJfcm9vdAlwZ29mZl90cmVlOw0KIAlp
bnQJCSgqdHJhbnNmZXIpKHN0cnVjdCBsb29wX2RldmljZSAqLCBpbnQgY21k
LA0KIAkJCQkgICAgc3RydWN0IHBhZ2UgKnJhd19wYWdlLCB1bnNpZ25lZCBy
YXdfb2ZmLA0KIAkJCQkgICAgc3RydWN0IHBhZ2UgKmxvb3BfcGFnZSwgdW5z
aWduZWQgbG9vcF9vZmYsDQpAQCAtNjYsNiArNjksMTEgQEAgc3RydWN0IGxv
b3BfZGV2aWNlIHsNCiAJcmVxdWVzdF9xdWV1ZV90CQkqbG9fcXVldWU7DQog
fTsNCiANCitzdHJ1Y3QgcGdvZmZfZWxlbSB7DQorCXN0cnVjdCByYl9ub2Rl
CQlub2RlOw0KKwl1bnNpZ25lZCBsb25nCQlvZmZzZXQ7DQorfTsNCisNCiAj
ZW5kaWYgLyogX19LRVJORUxfXyAqLw0KIA0KIC8qDQpAQCAtMTExLDYgKzEx
OSwxMyBAQCBzdHJ1Y3QgbG9vcF9pbmZvNjQgew0KIAlfX3U2NAkJICAgbG9f
aW5pdFsyXTsNCiB9Ow0KIA0KK3N0cnVjdCBsb29wX3Bnb2ZmX2FycmF5IHsN
CisJX191NjQgbWF4OwkvKiBzaXplIG9mIGFycmF5IHBhc3NlZCBieSB1c2Vy
ICovDQorCV9fdTY0IG51bTsJLyogbnVtYmVyIG9mIGVudHJpZXMgZmlsbGVk
IGluIGJ5IGRyaXZlciAqLw0KKwlfX3U2NCAqcGdvZmY7CS8qIGFycmF5IG9m
IHBhZ2Ugb2Zmc2V0cyBvZiBwYWdlcyB3cml0dGVuIHRvIGJ5IG1tYXAgKi8N
Cit9Ow0KKw0KKw0KIC8qDQogICogTG9vcCBmaWx0ZXIgdHlwZXMNCiAgKi8N
CkBAIC0xNTcsNSArMTcyLDggQEAgaW50IGxvb3BfdW5yZWdpc3Rlcl90cmFu
c2ZlcihpbnQgbnVtYmVyKQ0KICNkZWZpbmUgTE9PUF9TRVRfU1RBVFVTNjQJ
MHg0QzA0DQogI2RlZmluZSBMT09QX0dFVF9TVEFUVVM2NAkweDRDMDUNCiAj
ZGVmaW5lIExPT1BfQ0hBTkdFX0ZECQkweDRDMDYNCisjZGVmaW5lIExPT1Bf
U0VUX1RSQUNLX1BHV1JJVEUJMHg0QzA3DQorI2RlZmluZSBMT09QX0dFVF9Q
R1dSSVRFUwkweDRDMDgNCisjZGVmaW5lIExPT1BfQ0xSX1BHV1JJVEVTCTB4
NEMwOQ0KIA0KICNlbmRpZg0K

--1585517810-570499139-1173817301=:18655--
