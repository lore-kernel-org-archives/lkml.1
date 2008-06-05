Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYFESFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYFESFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYFESFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:05:42 -0400
Received: from saeurebad.de ([85.214.36.134]:34498 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbYFESFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:05:41 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Dave Airlie <airlied@redhat.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference (drm_getunique)
References: <g276vj$7f0$2@ger.gmane.org> <87y75kaeg7.fsf@saeurebad.de>
	<87wsl4aaft.fsf@saeurebad.de>
	<1212635129.24094.11.camel@clockmaker.usersys.redhat.com>
Date: Thu, 05 Jun 2008 20:04:50 +0200
In-Reply-To: <1212635129.24094.11.camel@clockmaker.usersys.redhat.com> (Dave
	Airlie's message of "Thu, 05 Jun 2008 13:05:29 +1000")
Message-ID: <87ve0n69ml.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dave Airlie <airlied@redhat.com> writes:

>> Make that run-time tested, also.  This does not just affect linux-next.
>> The following program oopses my box running Linus' current git:
>> 
>> #include <fcntl.h>
>> #include <unistd.h>
>> #include <sys/ioctl.h>
>> 
>> #include <drm/drm.h>
>> 
>> #define DRM_DFILE		"/dev/dri/card0"
>> #define DRM_IOCTL_CAPUT		_IO(DRM_IOCTL_BASE, 0x01)
>> 
>> int main(void)
>> {
>> 	int fd = open(DRM_DFILE, O_RDONLY);
>> 
>> 	if (fd < 0)
>> 		return 1;
>> 
>> 	ioctl(fd, DRM_IOCTL_CAPUT);
>> 	perror("ioctl");
>> 	close(fd);
>> 	return 0;
>> }
>> 
>> ->
>> 
>> [  714.581505] BUG: unable to handle kernel NULL pointer dereference at 00000000
>> [  714.583459] IP: [<c027d491>] drm_getunique+0x11/0x40
>> [  714.585460] *pde = 00000000 
>> [  714.587389] Oops: 0000 [#1] PREEMPT 
>> [  714.588271] Modules linked in: snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_page_alloc
>> [  714.588271] 
>> [  714.588271] Pid: 1339, comm: break-drm Not tainted (2.6.26-rc4-00232-gedeb280 #43)
>> [  714.588271] EIP: 0060:[<c027d491>] EFLAGS: 00010282 CPU: 0
>> [  714.588271] EIP is at drm_getunique+0x11/0x40
>> [  714.588271] EAX: cf861000 EBX: 00000000 ECX: 00000000 EDX: 00000000
>> [  714.588271] ESI: cf861000 EDI: cfa87700 EBP: 00000000 ESP: cecc3f20
>> [  714.588271]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>> [  714.588271] Process break-drm (pid: 1339, ti=cecc2000 task=cf9a6dc0 task.ti=cecc2000)
>> [  714.588271] Stack: c027d480 cf861000 c027c592 ced53b7c b7fc00d0 c0159f3b ced53b7c 000000ce 
>> [  714.588271]        00000000 00000000 00006401 00000000 cf861024 c04730a0 ced33700 bf965788 
>> [  714.588271]        00006401 c017aea8 bf965788 ced33700 ced33700 00000003 cecc2000 c017b0fb 
>> [  714.588271] Call Trace:
>> [  714.588271]  [<c027d480>] drm_getunique+0x0/0x40
>> [  714.588271]  [<c027c592>] drm_ioctl+0x1a2/0x2e0
>> [  714.588271]  [<c0159f3b>] handle_mm_fault+0xeb/0x5e0
>> [  714.588271]  [<c017aea8>] vfs_ioctl+0x78/0x90
>> [  714.588271]  [<c017b0fb>] do_vfs_ioctl+0x23b/0x2c0
>> [  714.588271]  [<c016ce2a>] do_sys_open+0xba/0xe0
>> [  714.588271]  [<c017b1bd>] sys_ioctl+0x3d/0x70
>> [  714.588271]  [<c0103152>] syscall_call+0x7/0xb
>> [  714.588271]  =======================
>> [  714.588271] Code: 8b 04 24 e8 e2 1b 12 00 31 c0 5b 5b 5e 5f 5d c3 8d 76 00 8d bc 27 00 00 00 00 83 ec 08 89 1c 24 89 d3 89 74 24 04 89 c6 8b 48 04 <39> 0a 73 11 89 0b 31 d2 8b 1c 24 89 d0 8b 74 24 04 83 c4 08 c3 
>> [  714.588271] EIP: [<c027d491>] drm_getunique+0x11/0x40 SS:ESP 0068:cecc3f20
>> [  714.659745] ---[ end trace fd8339ca8c62cb63 ]---
>> [  714.663840] [drm:drm_release] *ERROR* Device busy: 1 0
>> 
>> My patch fixes this, but here is a better one that checks the whole cmd
>> against the allowed one.  Otherwise, it would be possible to trap the
>> kernel into allocating 2^15-1 bytes through kmalloc, too, at least on
>> this configuration here with _IOC_SIZEBITS == 14.
>> 
>> ---
>> drm: sanity-check ioctl request
>> 
>> drm_ioctl looks up a dispatcher function for special ioctls but it does
>> not precheck the commands against the registered ones, allowing users to
>> pass bogus values and potentially oops the kernel, as happened to
>> Sitsofe Wheeler who reported this bug.
>> 
>> This patch checks the incoming ioctl command against the defined ones
>> before dispatching to the handler.
>> 
>
>
> This patch will break some other parts of the DRM interface, I'll try
> and come up with one that is less likely do stop all the drivers
> working.

We do not want that to happen, of course :)

> The problem is there are binaries out there with bad userspace ioctl
> bits..
>
> What I'll change it to do is at least allocate the size from the kernel
> definition not what the user passed in.
>
> The big problem we have with malformed requests is that userspace asks
> for one thing and expects another, so I should key the userspace from
> the ioctl nr and use the kernel side definitions to decide the other
> bits. Clearly the drm code isn't doing that now.

Hm, like this?

diff --git a/drivers/char/drm/drm_drv.c b/drivers/char/drm/drm_drv.c
index fc54140..019bf1f 100644
--- a/drivers/char/drm/drm_drv.c
+++ b/drivers/char/drm/drm_drv.c
@@ -475,6 +475,9 @@ int drm_ioctl(struct inode *inode, struct file *filp,
 	else
 		goto err_i1;
 
+	/* Do not trust userspace, use our own definition */
+	cmd = ioctl->cmd;
+
 	func = ioctl->func;
 	/* is there a local override? */
 	if ((nr == DRM_IOCTL_NR(DRM_IOCTL_DMA)) && dev->driver->dma_ioctl)
