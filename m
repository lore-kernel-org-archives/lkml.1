Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYCCMBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYCCMBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYCCMA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:00:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:59330 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbYCCMAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:00:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=mdmPLXz5a0512yYOnJROAAowJqjJGfEXl75YI1tPSHXU8sD2yA+Hpx0iiRODnoEUQFJeyYfVcwYeuK3hUa76Clo8KzDgdzCfdNhrzOBm83wB5PlYJ0K8+nkDAy8AtJ/stnKI/+pNYkX6xbXfqs+knZbHzPtZ1b3NnKAiu9wi4Ng=
Message-ID: <47CBE871.4090309@gmail.com>
Date: Mon, 03 Mar 2008 13:00:49 +0100
From: Jiri Olsa <olsajiri@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>, peifferp@gmail.com
Subject: Re: [BUG] soft lockup detected with ipcs
References: <47C7E280.4010805@gmail.com> <Pine.LNX.4.64.0802291241080.7699@twin.jikos.cz> <47CAE7D5.5040907@gmail.com> <20080302120236.61e0ec74.akpm@linux-foundation.org> <Pine.LNX.4.64.0803022214190.15209@jikos.suse.cz> <Pine.LNX.4.64.0803022223360.15209@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0803022223360.15209@jikos.suse.cz>
Content-Type: multipart/mixed;
 boundary="------------060502010609050705070701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060502010609050705070701
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jiri Kosina wrote:
> On Sun, 2 Mar 2008, Jiri Kosina wrote:
> 
>> Could you please try what is the output with the attached patch below, so 
>> that we know which spinlock buggers?
> 
> Uhm, and hereby I attach the patch.
> 
> diff --git a/ipc/shm.c b/ipc/shm.c
> index c47e872..2abfb70 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -615,6 +615,7 @@ static void shm_get_stat(struct ipc_namespace *ns, unsigned long *rss,
>  			*rss += (HPAGE_SIZE/PAGE_SIZE)*mapping->nrpages;
>  		} else {
>  			struct shmem_inode_info *info = SHMEM_I(inode);
> +			printk(KERN_DEBUG "info: %p\n", info);
>  			spin_lock(&info->lock);
>  			*rss += inode->i_mapping->nrpages;
>  			*swp += info->swapped;
> diff --git a/ipc/util.c b/ipc/util.c
> index fd1b50d..5a0d4d2 100644
> --- a/ipc/util.c
> +++ b/ipc/util.c
> @@ -662,6 +662,7 @@ struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
>  
>  	up_read(&ids->rw_mutex);
>  
> +	printk(KERN_DEBUG "out: %p\n", out);
>  	spin_lock(&out->lock);
>  	
>  	/* ipc_rmid() may have already freed the ID while ipc_lock

I'll try the patch, so far I attached the ipcs strace and adjacent kernel logs.

--------------060502010609050705070701
Content-Type: text/plain;
 name="ipcs.strace.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipcs.strace.out"

execve("/usr/bin/ipcs", ["ipcs"], [/* 37 vars */]) = 0
brk(0)                                  = 0x804e000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=60196, ...}) = 0
mmap2(NULL, 60196, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f2c000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@e\1\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1261852, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f2b000
mmap2(NULL, 1267248, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7df5000
mmap2(0xb7f25000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x130) = 0xb7f25000
mmap2(0xb7f28000, 9776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f28000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7df4000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7df46c0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb7f25000, 8192, PROT_READ)   = 0
mprotect(0x804c000, 4096, PROT_READ)    = 0
mprotect(0xb7f56000, 4096, PROT_READ)   = 0
munmap(0xb7f2c000, 60196)               = 0
brk(0)                                  = 0x804e000
brk(0x806f000)                          = 0x806f000
fstat64(1, {st_mode=S_IFCHR|0622, st_rdev=makedev(136, 0), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f3a000
write(1, "\n", 1)                       = 1
shmctl(0, IPC_64|SHM_INFO, 0xbfd9e9e0 <unfinished ...>
+++ killed by SIGSEGV +++

--------------060502010609050705070701
Content-Type: text/plain;
 name="ipcs.kernel.out.1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipcs.kernel.out.1"

[   85.868123] BUG: unable to handle kernel NULL pointer dereference at virtual address 000000bf
[   85.868149] printing eip: c0133034 *pde = 00000000 
[   85.868171] Oops: 0002 [#1] 
[   85.868184] Modules linked in: netconsole i915 drm configfs snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd snd_page_alloc ipw2200 e1000
[   85.868282] 
[   85.868290] Pid: 4973, comm: ipcs Not tainted (2.6.24.3test-dirty #19)
[   85.868302] EIP: 0060:[<c0133034>] EFLAGS: 00010086 CPU: 0
[   85.868315] EIP is at __lock_acquire+0x319/0xc20
[   85.868323] EAX: 00000002 EBX: 00000246 ECX: def4e4d4 EDX: 00000002
[   85.868331] ESI: ffffffff EDI: 00000000 EBP: d8fcfe7c ESP: d8fcfe20
[   85.868339]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   85.868347] Process ipcs (pid: 4973, ti=d8fce000 task=dd96d0d0 task.ti=d8fce000)
[   85.868354] Stack: c01338f4 d8fcfe88 c01338f4 d8fcfe4c 00000347 00000000 00000002 00000000 
[   85.868421]        00000000 def4e4d4 00000000 dd96d0d0 00000001 dd96d728 d8fcfebc c01338f4 
[   85.868491]        00000000 dd96d728 00000347 00000000 00000246 00000000 00000000 d8fcfea4 
[   85.868553] Call Trace:
[   85.868565]  [<c0103e9f>] show_trace_log_lvl+0x1a/0x2f
[   85.868582]  [<c0103f51>] show_stack_log_lvl+0x9d/0xa5
[   85.868606]  [<c0104006>] show_registers+0xad/0x17c
[   85.868620]  [<c01041cc>] die+0xf7/0x1c8
[   85.868633]  [<c0110e31>] do_page_fault+0x464/0x54b
[   85.868648]  [<c036259a>] error_code+0x6a/0x70
[   85.868667]  [<c01339b3>] lock_acquire+0x78/0x91
[   85.868680]  [<c0361f65>] _spin_lock+0x2e/0x58
[   85.868693]  [<c01dc5a6>] sys_shmctl+0x6f8/0x776
[   85.868713]  [<c0106d33>] sys_ipc+0x19f/0x1b5
[   85.868727]  [<c0102fa6>] syscall_call+0x7/0xb
[   85.868740]  =======================
[   85.868747] Code: 00 85 c0 0f 84 1d 09 00 00 83 3d 20 b4 78 c0 00 0f 85 10 09 00 00 c7 44 24 0c c8 ad 36 c0 c7 44 24 08 26 03 00 00 e9 8b 07 00 00 <ff> 86 c0 00 00 00 8b 45 d0 8b 80 54 06 00 00 83 f8 1d 89 45 cc 
[   85.869152] EIP: [<c0133034>] __lock_acquire+0x319/0xc20 SS:ESP 0068:d8fcfe20
[   85.869179] ---[ end trace 807f13dee3166302 ]---

--------------060502010609050705070701
Content-Type: text/plain;
 name="ipcs.kernel.out.2"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="ipcs.kernel.out.2"

WyAgMTExLjY1OTg2Nl0gQlVHOiBzb2Z0IGxvY2t1cCAtIENQVSMwIHN0dWNrIGZvciAxMXMh
IFtpcGNzOjQ5NzldDQpbICAxMTEuNjU5ODgxXSANClsgIDExMS42NTk4ODldIFBpZDogNDk3
OSwgY29tbTogaXBjcyBUYWludGVkOiBHICAgICAgRCAoMi42LjI0LjN0ZXN0LWRpcnR5ICMx
OSkNClsgIDExMS42NTk4OThdIEVJUDogMDA2MDpbPGMwMWYyNjcyPl0gRUZMQUdTOiAwMDAw
MDI0NiBDUFU6IDANClsgIDExMS42NTk5MTFdIEVJUCBpcyBhdCBkZWxheV90c2MrMHhlLzB4
MTcNClsgIDExMS42NTk5MTldIEVBWDogOThiNmJiOGYgRUJYOiAwMDAwMDAwMSBFQ1g6IDk4
YjZiYjVjIEVEWDogMDAwMDAwMjkNClsgIDExMS42NTk5MjddIEVTSTogMDkzY2EwYmYgRURJ
OiAwMDAwMDAwMSBFQlA6IGQ4ZjYzZTcwIEVTUDogZDhmNjNlNmMNClsgIDExMS42NTk5MzVd
ICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDAzMyBTUzogMDA2OA0KWyAgMTEx
LjY1OTk0M10gQ1IwOiA4MDA1MDAzYiBDUjI6IDA4MDUzYzMwIENSMzogMWU4NmMwMDAgQ1I0
OiAwMDAwMDZkMA0KWyAgMTExLjY1OTk1MV0gRFIwOiAwMDAwMDAwMCBEUjE6IDAwMDAwMDAw
IERSMjogMDAwMDAwMDAgRFIzOiAwMDAwMDAwMA0KWyAgMTExLjY1OTk1OV0gRFI2OiBmZmZm
MGZmMCBEUjc6IDAwMDAwNDAwDQpbICAxMTEuNjU5OTY3XSAgWzxjMDEwM2U5Zj5dIHNob3df
dHJhY2VfbG9nX2x2bCsweDFhLzB4MmYNClsgIDExMS42NTk5ODVdICBbPGMwMTA0Nzg0Pl0g
c2hvd190cmFjZSsweDEyLzB4MTQNClsgIDExMS42NTk5OThdICBbPGMwMTAxNjNlPl0gc2hv
d19yZWdzKzB4MWMvMHgxZg0KWyAgMTExLjY2MDAxMV0gIFs8YzAxM2I5Zjg+XSBzb2Z0bG9j
a3VwX3RpY2srMHhjZS8weGU3DQpbICAxMTEuNjYwMDI2XSAgWzxjMDEyMDJhNz5dIHJ1bl9s
b2NhbF90aW1lcnMrMHgxMi8weDE0DQpbICAxMTEuNjYwMDQyXSAgWzxjMDEyMDRiNj5dIHVw
ZGF0ZV9wcm9jZXNzX3RpbWVzKzB4MWIvMHgzZg0KWyAgMTExLjY2MDA1Nl0gIFs8YzAxMmYz
YTM+XSB0aWNrX3BlcmlvZGljKzB4NjUvMHg3MQ0KWyAgMTExLjY2MDA3Ml0gIFs8YzAxMmYz
YzE+XSB0aWNrX2hhbmRsZV9wZXJpb2RpYysweDEyLzB4NjENClsgIDExMS42NjAwODhdICBb
PGMwMTA1ZDI3Pl0gdGltZXJfaW50ZXJydXB0KzB4MzcvMHgzZQ0KWyAgMTExLjY2MDEwM10g
IFs8YzAxM2JjYWU+XSBoYW5kbGVfSVJRX2V2ZW50KzB4MWEvMHg0Ng0KWyAgMTExLjY2MDEx
OF0gIFs8YzAxM2QwZTM+XSBoYW5kbGVfbGV2ZWxfaXJxKzB4NmYvMHhiOA0KWyAgMTExLjY2
MDEzMl0gIFs8YzAxMDUxN2E+XSBkb19JUlErMHg3OC8weDhmDQpbICAxMTEuNjYwMTQ1XSAg
WzxjMDEwMzliNj5dIGNvbW1vbl9pbnRlcnJ1cHQrMHgyZS8weDM0DQpbICAxMTEuNjYwMTU5
XSAgWzxjMDFmMjY0OT5dIF9fZGVsYXkrMHg5LzB4Yg0KWyAgMTExLjY2MDE3M10gIFs8YzAx
ZmZlMTk+XSBfcmF3X3NwaW5fbG9jaysweDdmLzB4ZDgNClsgIDExMS42NjAxOTBdICBbPGMw
MzYxZjgxPl0gX3NwaW5fbG9jaysweDRhLzB4NTgNClsgIDExMS42NjAyMDddICBbPGMwMWRj
NWE2Pl0gc3lzX3NobWN0bCsweDZmOC8weDc3Ng0KWyAgMTExLjY2MDIyM10gIFs8YzAxMDZk
MzM+XSBzeXNfaXBjKzB4MTlmLzB4MWI1DQpbICAxMTEuNjYwMjM3XSAgWzxjMDEwMmZhNj5d
IHN5c2NhbGxfY2FsbCsweDcvMHhiDQpbICAxMTEuNjYwMjUzXSAgPT09PT09PT09PT09PT09
PT09PT09PT0NClsgIDExNC4zMzUyNjZdIGlwdzIyMDA6IEZpcm13YXJlIGVycm9yIGRldGVj
dGVkLiAgUmVzdGFydGluZy4NClsgIDExNC44MTQ4NjJdIGlwdzIyMDA6IEZpcm13YXJlIGVy
cm9yIGRldGVjdGVkLiAgUmVzdGFydGluZy4NClsgIDEyMy40NjI1MTRdIEJVRzogc29mdCBs
b2NrdXAgLSBDUFUjMCBzdHVjayBmb3IgMTFzISBbaXBjczo0OTc5XQ0KWyAgMTIzLjQ2MjUy
Ml0gDQpbICAxMjMuNDYyNTI5XSBQaWQ6IDQ5NzksIGNvbW06IGlwY3MgVGFpbnRlZDogRyAg
ICAgIEQgKDIuNi4yNC4zdGVzdC1kaXJ0eSAjMTkpDQpbICAxMjMuNDYyNTM3XSBFSVA6IDAw
NjA6WzxjMDFmMjY2ZT5dIEVGTEFHUzogMDAwMDAyNDYgQ1BVOiAwDQpbICAxMjMuNDYyNTQ1
XSBFSVAgaXMgYXQgZGVsYXlfdHNjKzB4YS8weDE3DQpbICAxMjMuNDYyNTUzXSBFQVg6IGZl
NGQ2M2Q0IEVCWDogMDAwMDAwMDEgRUNYOiBmZTRkNjNkNCBFRFg6IDAwMDAwMDJkDQpbICAx
MjMuNDYyNTYxXSBFU0k6IDEzMTZmNzQxIEVESTogMDAwMDAwMDEgRUJQOiBkOGY2M2U3MCBF
U1A6IGQ4ZjYzZTZjDQpbICAxMjMuNDYyNTY5XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAw
MDAgR1M6IDAwMzMgU1M6IDAwNjgNClsgIDEyMy40NjI1NzZdIENSMDogODAwNTAwM2IgQ1Iy
OiAwODA1M2MzMCBDUjM6IDFlODZjMDAwIENSNDogMDAwMDA2ZDANClsgIDEyMy40NjI1ODRd
IERSMDogMDAwMDAwMDAgRFIxOiAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwIERSMzogMDAwMDAw
MDANClsgIDEyMy40NjI1OTFdIERSNjogZmZmZjBmZjAgRFI3OiAwMDAwMDQwMA0KWyAgMTIz
LjQ2MjU5OF0gIFs8YzAxMDNlOWY+XSBzaG93X3RyYWNlX2xvZ19sdmwrMHgxYS8weDJmDQpb
ICAxMjMuNDYyNjEyXSAgWzxjMDEwNDc4ND5dIHNob3dfdHJhY2UrMHgxMi8weDE0DQpbICAx
MjMuNDYyNjI2XSAgWzxjMDEwMTYzZT5dIHNob3dfcmVncysweDFjLzB4MWYNClsgIDEyMy40
NjI2MzldICBbPGMwMTNiOWY4Pl0gc29mdGxvY2t1cF90aWNrKzB4Y2UvMHhlNw0KWyAgMTIz
LjQ2MjY1M10gIFs8YzAxMjAyYTc+XSBydW5fbG9jYWxfdGltZXJzKzB4MTIvMHgxNA0KWyAg
MTIzLjQ2MjY2N10gIFs8YzAxMjA0YjY+XSB1cGRhdGVfcHJvY2Vzc190aW1lcysweDFiLzB4
M2YNClsgIDEyMy40NjI2ODFdICBbPGMwMTJmM2EzPl0gdGlja19wZXJpb2RpYysweDY1LzB4
NzENClsgIDEyMy40NjI2OTZdICBbPGMwMTJmM2MxPl0gdGlja19oYW5kbGVfcGVyaW9kaWMr
MHgxMi8weDYxDQpbICAxMjMuNDYyNzEwXSAgWzxjMDEwNWQyNz5dIHRpbWVyX2ludGVycnVw
dCsweDM3LzB4M2UNClsgIDEyMy40NjI3MjRdICBbPGMwMTNiY2FlPl0gaGFuZGxlX0lSUV9l
dmVudCsweDFhLzB4NDYNClsgIDEyMy40NjI3MzhdICBbPGMwMTNkMGUzPl0gaGFuZGxlX2xl
dmVsX2lycSsweDZmLzB4YjgNClsgIDEyMy40NjI3NTFdICBbPGMwMTA1MTdhPl0gZG9fSVJR
KzB4NzgvMHg4Zg0KWyAgMTIzLjQ2Mjc2NV0gIFs8YzAxMDM5YjY+XSBjb21tb25faW50ZXJy
dXB0KzB4MmUvMHgzNA0KWyAgMTIzLjQ2Mjc3OV0gIFs8YzAxZjI2NDk+XSBfX2RlbGF5KzB4
OS8weGINClsgIDEyMy40NjI3OTJdICBbPGMwMWZmZTE5Pl0gX3Jhd19zcGluX2xvY2srMHg3
Zi8weGQ4DQpbICAxMjMuNDYyODA2XSAgWzxjMDM2MWY4MT5dIF9zcGluX2xvY2srMHg0YS8w
eDU4DQpbICAxMjMuNDYyODE5XSAgWzxjMDFkYzVhNj5dIHN5c19zaG1jdGwrMHg2ZjgvMHg3
NzYNClsgIDEyMy40NjI4MzNdICBbPGMwMTA2ZDMzPl0gc3lzX2lwYysweDE5Zi8weDFiNQ0K
WyAgMTIzLjQ2Mjg0Nl0gIFs8YzAxMDJmYTY+XSBzeXNjYWxsX2NhbGwrMHg3LzB4Yg0KWyAg
MTIzLjQ2Mjg1OV0gID09PT09PT09PT09PT09PT09PT09PT09DQpbICAxNDcuMDYzODE5XSBC
VUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzAgc3R1Y2sgZm9yIDExcyEgW2lwY3M6NDk3OV0NClsg
IDE0Ny4wNjM4MjddDQpbICAxNDcuMDYzODM0XSBQaWQ6IDQ5NzksIGNvbW06IGlwY3MgVGFp
bnRlZDogRyAgICAgIEQgKDIuNi4yNC4zdGVzdC1kaXJ0eSAjMTkpDQpbICAxNDcuMDYzODQy
XSBFSVA6IDAwNjA6WzxjMDFmMjY2Yz5dIEVGTEFHUzogMDAwMDAyNDYgQ1BVOiAwDQpbICAx
NDcuMDYzODUwXSBFSVAgaXMgYXQgZGVsYXlfdHNjKzB4OC8weDE3DQpbICAxNDcuMDYzODU4
XSBFQVg6IGM5MTkyMDYxIEVCWDogMDAwMDAwMDEgRUNYOiBjOTE5MWZlZiBFRFg6IDAwMDAw
MDM2DQpbICAxNDcuMDYzODY2XSBFU0k6IDI2Y2IwMjRlIEVESTogMDAwMDAwMDEgRUJQOiBk
OGY2M2U3MCBFU1A6IGQ4ZjYzZTZjDQpbICAxNDcuMDYzODczXSAgRFM6IDAwN2IgRVM6IDAw
N2IgRlM6IDAwMDAgR1M6IDAwMzMgU1M6IDAwNjgNClsgIDE0Ny4wNjM4ODFdIENSMDogODAw
NTAwM2IgQ1IyOiAwODA1M2MzMCBDUjM6IDFlODZjMDAwIENSNDogMDAwMDA2ZDANClsgIDE0
Ny4wNjM4ODldIERSMDogMDAwMDAwMDAgRFIxOiAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwIERS
MzogMDAwMDAwMDANClsgIDE0Ny4wNjM4OTZdIERSNjogZmZmZjBmZjAgRFI3OiAwMDAwMDQw
MA0KWyAgMTQ3LjA2MzkwM10gIFs8YzAxMDNlOWY+XSBzaG93X3RyYWNlX2xvZ19sdmwrMHgx
YS8weDJmDQpbICAxNDcuMDYzOTE3XSAgWzxjMDEwNDc4ND5dIHNob3dfdHJhY2UrMHgxMi8w
eDE0DQpbICAxNDcuMDYzOTMwXSAgWzxjMDEwMTYzZT5dIHNob3dfcmVncysweDFjLzB4MWYN
ClsgIDE0Ny4wNjM5NDRdICBbPGMwMTNiOWY4Pl0gc29mdGxvY2t1cF90aWNrKzB4Y2UvMHhl
Nw0KWyAgMTQ3LjA2Mzk1OF0gIFs8YzAxMjAyYTc+XSBydW5fbG9jYWxfdGltZXJzKzB4MTIv
MHgxNA0KWyAgMTQ3LjA2Mzk3Ml0gIFs8YzAxMjA0YjY+XSB1cGRhdGVfcHJvY2Vzc190aW1l
cysweDFiLzB4M2YNClsgIDE0Ny4wNjM5ODZdICBbPGMwMTJmM2EzPl0gdGlja19wZXJpb2Rp
YysweDY1LzB4NzENClsgIDE0Ny4wNjQwMDBdICBbPGMwMTJmM2MxPl0gdGlja19oYW5kbGVf
cGVyaW9kaWMrMHgxMi8weDYxDQpbICAxNDcuMDY0MDE0XSAgWzxjMDEwNWQyNz5dIHRpbWVy
X2ludGVycnVwdCsweDM3LzB4M2UNClsgIDE0Ny4wNjQwMjddICBbPGMwMTNiY2FlPl0gaGFu
ZGxlX0lSUV9ldmVudCsweDFhLzB4NDYNClsgIDE0Ny4wNjQwNDFdICBbPGMwMTNkMGUzPl0g
aGFuZGxlX2xldmVsX2lycSsweDZmLzB4YjgNClsgIDE0Ny4wNjQwNTVdICBbPGMwMTA1MTdh
Pl0gZG9fSVJRKzB4NzgvMHg4Zg0KWyAgMTQ3LjA2NDA2OF0gIFs8YzAxMDM5YjY+XSBjb21t
b25faW50ZXJydXB0KzB4MmUvMHgzNA0KWyAgMTQ3LjA2NDA4MV0gIFs8YzAxZjI2NDk+XSBf
X2RlbGF5KzB4OS8weGINClsgIDE0Ny4wNjQwOTVdICBbPGMwMWZmZTE5Pl0gX3Jhd19zcGlu
X2xvY2srMHg3Zi8weGQ4DQpbICAxNDcuMDY0MTA5XSAgWzxjMDM2MWY4MT5dIF9zcGluX2xv
Y2srMHg0YS8weDU4DQpbICAxNDcuMDY0MTIyXSAgWzxjMDFkYzVhNj5dIHN5c19zaG1jdGwr
MHg2ZjgvMHg3NzYNClsgIDE0Ny4wNjQxMzVdICBbPGMwMTA2ZDMzPl0gc3lzX2lwYysweDE5
Zi8weDFiNQ0KWyAgMTQ3LjA2NDE0OF0gIFs8YzAxMDJmYTY+XSBzeXNjYWxsX2NhbGwrMHg3
LzB4Yg0KWyAgMTQ3LjA2NDE2Ml0gID09PT09PT09PT09PT09PT09PT09PT09DQpbICAxNTgu
ODYyNDczXSBCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzAgc3R1Y2sgZm9yIDExcyEgW2lwY3M6
NDk3OV0NClsgIDE1OC44NjI0ODFdDQpbICAxNTguODYyNDg4XSBQaWQ6IDQ5NzksIGNvbW06
IGlwY3MgVGFpbnRlZDogRyAgICAgIEQgKDIuNi4yNC4zdGVzdC1kaXJ0eSAjMTkpDQpbICAx
NTguODYyNDk2XSBFSVA6IDAwNjA6WzxjMDFmMjY3ND5dIEVGTEFHUzogMDAwMDAyMDYgQ1BV
OiAwDQpbICAxNTguODYyNTA0XSBFSVAgaXMgYXQgZGVsYXlfdHNjKzB4MTAvMHgxNw0KWyAg
MTU4Ljg2MjUxMV0gRUFYOiAwMDAwMDAzMyBFQlg6IDAwMDAwMDAxIEVDWDogMmU0ZTM0MTYg
RURYOiAwMDAwMDAzYg0KWyAgMTU4Ljg2MjUxOV0gRVNJOiAzMGE0YWE4NiBFREk6IDAwMDAw
MDAxIEVCUDogZDhmNjNlNzAgRVNQOiBkOGY2M2U2Yw0KWyAgMTU4Ljg2MjUyN10gIERTOiAw
MDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMDMzIFNTOiAwMDY4DQpbICAxNTguODYyNTM1
XSBDUjA6IDgwMDUwMDNiIENSMjogMDgwNTNjMzAgQ1IzOiAxZTg2YzAwMCBDUjQ6IDAwMDAw
NmQwDQpbICAxNTguODYyNTQyXSBEUjA6IDAwMDAwMDAwIERSMTogMDAwMDAwMDAgRFIyOiAw
MDAwMDAwMCBEUjM6IDAwMDAwMDAwDQpbICAxNTguODYyNTUwXSBEUjY6IGZmZmYwZmYwIERS
NzogMDAwMDA0MDANClsgIDE1OC44NjI1NTZdICBbPGMwMTAzZTlmPl0gc2hvd190cmFjZV9s
b2dfbHZsKzB4MWEvMHgyZg0KWyAgMTU4Ljg2MjU3MF0gIFs8YzAxMDQ3ODQ+XSBzaG93X3Ry
YWNlKzB4MTIvMHgxNA0KWyAgMTU4Ljg2MjU4NF0gIFs8YzAxMDE2M2U+XSBzaG93X3JlZ3Mr
MHgxYy8weDFmDQpbICAxNTguODYyNTk4XSAgWzxjMDEzYjlmOD5dIHNvZnRsb2NrdXBfdGlj
aysweGNlLzB4ZTcNClsgIDE1OC44NjI2MTFdICBbPGMwMTIwMmE3Pl0gcnVuX2xvY2FsX3Rp
bWVycysweDEyLzB4MTQNClsgIDE1OC44NjI2MjVdICBbPGMwMTIwNGI2Pl0gdXBkYXRlX3By
b2Nlc3NfdGltZXMrMHgxYi8weDNmDQpbICAxNTguODYyNjQwXSAgWzxjMDEyZjNhMz5dIHRp
Y2tfcGVyaW9kaWMrMHg2NS8weDcxDQpbICAxNTguODYyNjU0XSAgWzxjMDEyZjNjMT5dIHRp
Y2tfaGFuZGxlX3BlcmlvZGljKzB4MTIvMHg2MQ0KWyAgMTU4Ljg2MjY2N10gIFs8YzAxMDVk
Mjc+XSB0aW1lcl9pbnRlcnJ1cHQrMHgzNy8weDNlDQpbICAxNTguODYyNjgxXSAgWzxjMDEz
YmNhZT5dIGhhbmRsZV9JUlFfZXZlbnQrMHgxYS8weDQ2DQpbICAxNTguODYyNjk0XSAgWzxj
MDEzZDBlMz5dIGhhbmRsZV9sZXZlbF9pcnErMHg2Zi8weGI4DQpbICAxNTguODYyNzA4XSAg
WzxjMDEwNTE3YT5dIGRvX0lSUSsweDc4LzB4OGYNClsgIDE1OC44NjI3MjJdICBbPGMwMTAz
OWI2Pl0gY29tbW9uX2ludGVycnVwdCsweDJlLzB4MzQNClsgIDE1OC44NjI3MzVdICBbPGMw
MWYyNjQ5Pl0gX19kZWxheSsweDkvMHhiDQpbICAxNTguODYyNzQ5XSAgWzxjMDFmZmUxOT5d
IF9yYXdfc3Bpbl9sb2NrKzB4N2YvMHhkOA0KWyAgMTU4Ljg2Mjc2M10gIFs8YzAzNjFmODE+
XSBfc3Bpbl9sb2NrKzB4NGEvMHg1OA0KWyAgMTU4Ljg2Mjc3Nl0gIFs8YzAxZGM1YTY+XSBz
eXNfc2htY3RsKzB4NmY4LzB4Nzc2DQpbICAxNTguODYyNzg5XSAgWzxjMDEwNmQzMz5dIHN5
c19pcGMrMHgxOWYvMHgxYjUNClsgIDE1OC44NjI4MDJdICBbPGMwMTAyZmE2Pl0gc3lzY2Fs
bF9jYWxsKzB4Ny8weGINClsgIDE1OC44NjI4MTddICA9PT09PT09PT09PT09PT09PT09PT09
PQ==
--------------060502010609050705070701--
