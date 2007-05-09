Return-Path: <linux-kernel-owner+w=401wt.eu-S969066AbXEIBpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969066AbXEIBpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968552AbXEIBpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:45:41 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35348 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968447AbXEIBpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:45:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: yhlu <yhlu.kernel@gmail.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       vgoyal@in.ibm.com, Gerd Hoffmann <kraxel@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <4634483E.9030307@goop.org>
	<m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
	<86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
	<m1sla7i68s.fsf@ebiederm.dsl.xmission.com>
	<86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>
	<86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>
	<m1k5vji107.fsf@ebiederm.dsl.xmission.com>
	<86802c440705081500x682ee098y7d51f7bb98dbcff6@mail.gmail.com>
	<4640F4B3.30408@goop.org> <4640FB2C.2060300@zytor.com>
	<86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com>
	<46410403.4050802@zytor.com>
Date: Tue, 08 May 2007 19:44:25 -0600
In-Reply-To: <46410403.4050802@zytor.com> (H. Peter Anvin's message of "Tue,
	08 May 2007 16:13:07 -0700")
Message-ID: <m17irivkhy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> yhlu wrote:
>> On 5/8/07, H. Peter Anvin <hpa@zytor.com> wrote:
>>> Jeremy Fitzhardinge wrote:
>>> Specifically boot_params.screen_info isn't being properly set up by the
>>> caller.
>> 
>> will setup real_mode_data in kexec path?
>
> -ENOPARSE

I believe YH is asking how we setup real_mode_data in /sbin/kexec.
The setup is:
>         real_mode->orig_x = 0;
>         real_mode->orig_y = 0;
>         real_mode->orig_video_page = 0;
>         real_mode->orig_video_mode = 0;
>         real_mode->orig_video_cols = 80;
>         real_mode->orig_video_lines = 25;
>         real_mode->orig_video_ega_bx = 0;
>         real_mode->orig_video_isVGA = 1;
>         real_mode->orig_video_points = 16;

Silly but generally safe.

More relevant because the code is in kernel we have:

arch/arm/kernel/setup.c:
> struct screen_info screen_info = {
>  .orig_video_lines	= 30,
>  .orig_video_cols	= 80,
>  .orig_video_mode	= 0,
>  .orig_video_ega_bx	= 0,
>  .orig_video_isVGA	= 1,
>  .orig_video_points	= 8
> };


arch/alpha/kernel/sys_sio.c:
> 	/* The AlphaBook1 has LCD video fixed at 800x600,
> 	   37 rows and 100 cols. */
> 	screen_info.orig_y = 37;
> 	screen_info.orig_video_cols = 100;
> 	screen_info.orig_video_lines = 37;


I expect I can find a few more examples where we specify
video_cols and video_lines but we use video_mode == 0.

Going farther mode 0x00 is a BIOS 40x25 mode.  So the patch below is
not always safe even if we boot the bzImage.  It is just highly
unlikely anyone would start the kernel in 40x25 text mode. 

Therefore I expect the test should test several additional
fields, in particular video lines and columns before we
decide that we have an uninitialized screen_info and give up.


> commit f82af20e1a028e16b9bb11da081fa1148d40fa6a
> Author: Gerd Hoffmann <kraxel@suse.de>
> Date:   Wed May 2 19:27:19 2007 +0200
> 
>     [PATCH] x86-64: ignore vgacon if hardware not present
>     
>     Avoid trying to set up vgacon if there's no vga hardware present.
>     
>     Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>     Signed-off-by: Andi Kleen <ak@suse.de>
>     Cc: Alan <alan@lxorguk.ukuu.org.uk>
>     Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
> index 91a2078..3e67c34 100644
> --- a/drivers/video/console/vgacon.c
> +++ b/drivers/video/console/vgacon.c
> @@ -371,7 +371,8 @@ static const char *vgacon_startup(void)
>         }
>  
>         /* VGA16 modes are not handled by VGACON */
> -       if ((ORIG_VIDEO_MODE == 0x0D) ||        /* 320x200/4 */
> +       if ((ORIG_VIDEO_MODE == 0x00) ||        /* SCREEN_INFO not initialized */
> +           (ORIG_VIDEO_MODE == 0x0D) ||        /* 320x200/4 */
>             (ORIG_VIDEO_MODE == 0x0E) ||        /* 640x200/4 */
>             (ORIG_VIDEO_MODE == 0x10) ||        /* 640x350/4 */
>             (ORIG_VIDEO_MODE == 0x12) ||        /* 640x480/4 */

Eric
