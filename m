Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbXHBJEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbXHBJEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 05:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXHBJEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 05:04:13 -0400
Received: from xsmtp1.ethz.ch ([82.130.70.13]:16506 "EHLO xsmtp1.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbXHBJEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 05:04:12 -0400
Message-ID: <46B19E0A.5040605@inf.ethz.ch>
Date: Thu, 02 Aug 2007 11:04:10 +0200
From: Stefan Walter <stefan.walter@inf.ethz.ch>
User-Agent: Mail/News 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Steve Dickson <SteveD@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: rpc.mountd crashes when extensively using netgroups
References: <46ADDFB2.9070709@inf.ethz.ch> <46AF4034.6080507@RedHat.com>
In-Reply-To: <46AF4034.6080507@RedHat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Aug 2007 09:04:10.0353 (UTC) FILETIME=[16CD3E10:01C7D4E4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Dickson wrote:
> Stefan Walter wrote:
>>
>> We do this on a much larger scale though. The bug we ran into is
>> in line 96 in utils/mountd/auth.c. The strcpy can corrupt
>> memory when it copies the string returned by client_compose() to
>> my_client.m_hostname which has a fixed size of 1024 bytes. For our
>> example above, client_compose() returns "@joe,@jane"
>> for any machine in the offices_1 netgroup. Unfortunately we have
>> a machine to which roughly 150 netgroups like @joe or @jane
>> export to and client_compose() returns a string over 1300 bytes
>> long and rpc.mountd nicely segfaults.
>>  
>> To prevent the crash is of course trivial: Inserting a simple
>> 'if (strlen(n) > 1024) return NULL;' before line 96 does the job.
> Does the attached patch help?
>
rpc.mountd does not crash anymore but I get a 'permission denied' when
trying
to mount a share. Doing an 'strace rpc.mountd -F' reveals:

...
open("/proc/net/rpc/auth.unix.ip/channel", O_WRONLY|O_CREAT|O_TRUNC,
0666) = 9
fstat64(9, {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7f41000
time(NULL)                              = 1186041882
write(9, "nfsd 129.132.10.33 1186043682 @a"..., 1024) = -1 EINVAL
(Invalid argument)
write(9, "\n", 1)                       = -1 EINVAL (Invalid argument)
close(9)                                = 0
munmap(0xb7f41000, 4096)                = 0
open("/proc/net/rpc/nfsd.export/channel", O_WRONLY|O_CREAT|O_TRUNC,
0666) = 9
fstat64(9, {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7f41000
write(9, "@anbuehle,@anhorni,@antoinet,@ap"..., 1024) = -1 EINVAL
(Invalid argument)
time(NULL)                              = 1186041882
write(9, "/export/groups/grossm/h1/home/gr"..., 68) = -1 ENOENT (No such
file or directory)
close(9)                                = 0
munmap(0xb7f41000, 4096)                = 0
open("/proc/fs/nfsd/filehandle", O_RDWR) = 9
fstat64(9, {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7f41000
write(9, "@anbuehle,@anhorni,@antoinet,@ap"..., 1066) = -1 EPERM
(Operation not permitted)
...

>>
>> Our ultimate goal is to get Red Hat fix the code in nfs-utils 1.0.6
>> that is used in RHEL4. A first step would be to get a suitable fix in
>> the current nfs-utils. 
> Please open up bugs on all three of these issues and
> we'll see what can done...
>

Just did that (request IDs 1765949, 1765938 and 1765930 on sourceforge).

- Stefan

