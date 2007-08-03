Return-Path: <linux-kernel-owner+w=401wt.eu-S1762956AbXHCOwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762956AbXHCOwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761765AbXHCOvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:51:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761911AbXHCOvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:51:54 -0400
Message-ID: <46B340FC.7030209@RedHat.com>
Date: Fri, 03 Aug 2007 10:51:40 -0400
From: Steve Dickson <SteveD@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070529)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Stefan Walter <stefan.walter@inf.ethz.ch>, linux-kernel@vger.kernel.org
Subject: Re: rpc.mountd crashes when extensively using netgroups
References: <46ADDFB2.9070709@inf.ethz.ch> <46AF4034.6080507@RedHat.com> <46B19E0A.5040605@inf.ethz.ch> <alpine.LFD.0.999.0708030801090.23798@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708030801090.23798@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Satyam Sharma wrote:
> Hi,
> 
> 
> On Thu, 2 Aug 2007, Stefan Walter wrote:
> 
>> Steve Dickson wrote:
>>> Stefan Walter wrote:
>>>> We do this on a much larger scale though. The bug we ran into is
>>>> in line 96 in utils/mountd/auth.c. The strcpy can corrupt
>>>> memory when it copies the string returned by client_compose() to
>>>> my_client.m_hostname which has a fixed size of 1024 bytes. For our
>>>> example above, client_compose() returns "@joe,@jane"
>>>> for any machine in the offices_1 netgroup. Unfortunately we have
>>>> a machine to which roughly 150 netgroups like @joe or @jane
>>> export to and client_compose() returns a string over 1300 bytes
>>>> long and rpc.mountd nicely segfaults.
>>>>  
>>>> To prevent the crash is of course trivial: Inserting a simple
>>>> 'if (strlen(n) > 1024) return NULL;' before line 96 does the job.
>>> Does the attached patch help?
>>>
>> rpc.mountd does not crash anymore but I get a 'permission denied' when
>> trying
>> to mount a share. Doing an 'strace rpc.mountd -F' reveals:
>>
>> ...
>> open("/proc/net/rpc/auth.unix.ip/channel", O_WRONLY|O_CREAT|O_TRUNC,
>> 0666) = 9
>> fstat64(9, {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
>> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
>> 0) = 0xb7f41000
>> time(NULL)                              = 1186041882
>> write(9, "nfsd 129.132.10.33 1186043682 @a"..., 1024) = -1 EINVAL
>> (Invalid argument)
>> write(9, "\n", 1)                       = -1 EINVAL (Invalid argument)
>> close(9)                                = 0
>> munmap(0xb7f41000, 4096)                = 0
>> open("/proc/net/rpc/nfsd.export/channel", O_WRONLY|O_CREAT|O_TRUNC,
>> 0666) = 9
>> fstat64(9, {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
>> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
>> 0) = 0xb7f41000
>> write(9, "@anbuehle,@anhorni,@antoinet,@ap"..., 1024) = -1 EINVAL
>> (Invalid argument)
>> time(NULL)                              = 1186041882
>> write(9, "/export/groups/grossm/h1/home/gr"..., 68) = -1 ENOENT (No such
>> file or directory)
>> close(9)                                = 0
>> munmap(0xb7f41000, 4096)                = 0
>> open("/proc/fs/nfsd/filehandle", O_RDWR) = 9
>> fstat64(9, {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
>> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
>> 0) = 0xb7f41000
>> write(9, "@anbuehle,@anhorni,@antoinet,@ap"..., 1066) = -1 EPERM
>> (Operation not permitted)
>> ...
> 
> Yup, the snprintf() in the patch would've truncated the input string.
> 
> Steve (D), you should check the return of snprintf() and compare against
> the size specified (NFSCLNT_IDMAX+1) and do a graceful cleanup + print
> an error message to the user, when detecting truncation of input:
> 
> 
> err = snprintf(my_client.m_hostname, (NFSCLNT_IDMAX+1), "%s", *n?n:"DEFAULT");
> if (err >= (NFSCLNT_IDMAX+1)) {
> 	printf("too large input string ...\n");
> 	/* cleanups and graceful exit */
> }
> 
cool... thanks!

steved.
