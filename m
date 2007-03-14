Return-Path: <linux-kernel-owner+w=401wt.eu-S1030825AbXCNJuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030825AbXCNJuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030842AbXCNJuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:50:19 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57157 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030825AbXCNJuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:50:18 -0400
Date: Wed, 14 Mar 2007 10:50:16 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Al Viro <viro@ftp.linux.org.uk>
cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] fix ps3fb glue allowing a modular build
In-Reply-To: <E1HRPbU-0003Ha-Oq@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.62.0703141040030.28462@pademelon.sonytel.be>
References: <E1HRPbU-0003Ha-Oq@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

NAK

There are several problems with making it modular. I did try, cfr. the
incomplete patchlets below.

> ---
>  arch/powerpc/platforms/ps3/htab.c |    2 ++
>  drivers/video/Kconfig             |    2 +-
>  include/asm-powerpc/ps3fb.h       |    5 -----
>  3 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/ps3/htab.c b/arch/powerpc/platforms/ps3/htab.c
> index e12e59f..67d6f58 100644
> --- a/arch/powerpc/platforms/ps3/htab.c
> +++ b/arch/powerpc/platforms/ps3/htab.c
> @@ -235,7 +235,9 @@ static void ps3_hpte_invalidate(unsigned long slot, unsigned long va,
>  static void ps3_hpte_clear(void)
>  {
>  	/* Make sure to clean up the frame buffer device first */
> +#ifdef CONFIG_PS3_FB
>  	ps3fb_cleanup();
> +#endif

I'm not sure it will survive a kexec() of a new kernel if ps3fb_cleanup()
isn't called when ps3fb.ko has been loaded. But that's an issue for later...

> index ad81cf4..a447387 100644
> --- a/include/asm-powerpc/ps3fb.h
> +++ b/include/asm-powerpc/ps3fb.h
> @@ -43,13 +43,8 @@ struct ps3fb_ioctl_res {
>  
>  #ifdef __KERNEL__
>  
> -#ifdef CONFIG_FB_PS3
>  extern void ps3fb_flip_ctl(int on);
>  extern void ps3fb_cleanup(void);
> -#else
> -static inline void ps3fb_flip_ctl(int on) {}
> -static inline void ps3fb_cleanup(void) {}
> -#endif

Now it fails to link with:

| drivers/built-in.o: In function `ps3av_cmd_avb_param':ps3-linux-2.6.21-rc3/drivers/ps3/ps3av_cmd.c:855: undefined reference to `.ps3fb_flip_ctl'
| :ps3-linux-2.6.21-rc3/drivers/ps3/ps3av_cmd.c:869: undefined reference to `.ps3fb_flip_ctl'

Which could be fixed with something like:

--- ps3-linux-2.6.20.orig/drivers/ps3/ps3av.c
+++ ps3-linux-2.6.20/drivers/ps3/ps3av.c
@@ -868,6 +868,22 @@ int ps3av_dev_close(void)
 
 EXPORT_SYMBOL_GPL(ps3av_dev_close);
 
+void ps3av_register_flip_ctl(void (*flip_ctl)(int on))
+{
+	mutex_lock(&ps3av.mutex);
+	ps3av.flip_ctl = flip_ctl;
+	mutex_unlock(&ps3av.mutex);
+}
+EXPORT_SYMBOL_GPL(ps3av_register_flip_ctl);
+
+void ps3av_flip_ctl(int on)
+{
+	mutex_lock(&ps3av.mutex);
+	if (ps3av.flip_ctl)
+		ps3av.flip_ctl(on);
+	mutex_unlock(&ps3av.mutex);
+}
+
 static int ps3av_probe(struct ps3_vuart_port_device *dev)
 {
 	int res;
--- ps3-linux-2.6.20.orig/drivers/ps3/ps3av_cmd.c
+++ ps3-linux-2.6.20/drivers/ps3/ps3av_cmd.c
@@ -852,7 +852,7 @@ int ps3av_cmd_avb_param(struct ps3av_pkt
 {
 	int res;
 
-	ps3fb_flip_ctl(0);	/* flip off */
+	ps3av_flip_ctl(0);	/* flip off */
 
 	/* avb packet */
 	res = ps3av_do_pkt(PS3AV_CID_AVB_PARAM, send_len, sizeof(*avb),
@@ -866,7 +866,7 @@ int ps3av_cmd_avb_param(struct ps3av_pkt
 			 res);
 
       out:
-	ps3fb_flip_ctl(1);	/* flip on */
+	ps3av_flip_ctl(1);	/* flip on */
 	return res;
 }
 
--- ps3-linux-2.6.20.orig/include/asm-powerpc/ps3av.h
+++ ps3-linux-2.6.20/include/asm-powerpc/ps3av.h
@@ -660,6 +660,7 @@ struct ps3av {
 	u32 audio_port;
 	int ps3av_mode;
 	int ps3av_mode_old;
+	void (*flip_ctl)(int on);
 };
 
 /** command status **/
@@ -734,5 +735,7 @@ extern int ps3av_video_mute(int);
 extern int ps3av_audio_mute(int);
 extern int ps3av_dev_open(void);
 extern int ps3av_dev_close(void);
+extern void ps3av_register_flip_ctl(void (*func)(int on));
+extern void ps3av_flip_ctl(int on);
 
 #endif	/* _ASM_POWERPC_PS3AV_H_ */

and calling ps3av_register_flip_ctl() from ps3fb at the appropriate places.

Still, the module won't load, as ps3fb needs ps3fb_videomemory[] (do you
know a better way to allocate a few mebibytes of physically contiguous
memory?):

--- ps3-linux-2.6.20.orig/arch/powerpc/platforms/ps3/setup.c
+++ ps3-linux-2.6.20/arch/powerpc/platforms/ps3/setup.c
@@ -115,12 +115,13 @@ static void prealloc(struct ps3_prealloc
 	       p->address);
 }
 
-#ifdef CONFIG_FB_PS3
+#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE)
 struct ps3_prealloc ps3fb_videomemory = {
     .name = "ps3fb videomemory",
     .size = CONFIG_FB_PS3_DEFAULT_SIZE_M*1024*1024,
     .align = 1024*1024			/* the GPU requires 1 MiB alignment */
 };
+EXPORT_SYMBOL_GPL(ps3fb_videomemory);
 #define prealloc_ps3fb_videomemory()	prealloc(&ps3fb_videomemory)
 
 static int __init early_parse_ps3fb(char *p)

And finally, make sure CONFIG_LOGO=n, as there's a bug in the logo code: logos
are __initdata but the logo code still tries to draw them for a modular fbdev.
Originally (eons ago) this case was handled by the flag initmem_freed, which no
longer exists.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
