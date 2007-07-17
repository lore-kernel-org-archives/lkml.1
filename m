Return-Path: <linux-kernel-owner+w=401wt.eu-S936904AbXGQX21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936904AbXGQX21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762079AbXGQX2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:28:18 -0400
Received: from mailfe12.tele2.it ([212.247.155.109]:42223 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758430AbXGQX2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:28:17 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2007 19:28:17 EDT
X-Cloudmark-Score: 0.000000 []
Message-ID: <469D4279.1050602@inwind.it>
Date: Wed, 18 Jul 2007 00:28:09 +0200
From: federico ferri <xaero@inwind.it>
User-Agent: Thunderbird 2.0.0.4 (X11/20070716)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] change SysRq keycode for systems without SysRq key
References: <4697ECA1.4070200@inwind.it> <20070716235748.33d50a53.akpm@linux-foundation.org>
In-Reply-To: <20070716235748.33d50a53.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton ha scritto:
 > Seems harmless enough ;)
 >
 > Could you please send in a suitable update to Documentation/sysrq.txt?

sorry, I should have written a few lines here...
issue solved (sorry for not CCing here, I'm shy ((: ) resulting in no 
need for a patch, just the need of a recent kernel and a userspace program.

I report here the full discussion I had with Linus Torvalds, Dmitry 
Torokhov (CCed to linux-input list):


 >>>>> this patch adds an entry in Kconfig after 'config MAGIC_SYSRQ' which
 >>>>> asks for a different keycode (replacing also KEY_SYSRQ with
 >>>>> CONFIG_MAGIC_SYSRQ_KEYCODE in char/keyboard.c)
 >>>>>
 >>>>> Federico
 >>>>
 >>>> Quite frankly, I think that if we want to make something like this
 >>>> configurable, it should be dynamic, not compiled-in. So that the same
 >>>> kernel image can be used with different keyboards.
 >>>>
 >>>>         Linus
 >>> (I can imagine it could be done via a /proc/sysrq-keycode virtual file,
 >>> but that's just one possibility)
 >>>
 >>> So, this should turn into a feature request...
 >>> would you accept feature requests?  ( :
 >>>
 >>> Federico
 >>
 >> Well, this is totally untested, and I won't guarantee that this 
works at
 >> all, but this is how to generally do these kinds of things..
 >>
 >>         Linus
 >>
 >> ---
 >>  drivers/char/keyboard.c |    6 +++++-
 >>  1 files changed, 5 insertions(+), 1 deletions(-)
 >>
 >> diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
 >> index 90965b4..e21f52b 100644
 >> --- a/drivers/char/keyboard.c
 >> +++ b/drivers/char/keyboard.c
 >> @@ -157,6 +157,10 @@ static int sysrq_alt_use;
 >>  #endif
 >>  static int sysrq_alt;
 >> 
 >> +static int sysrq_key = KEY_SYSRQ;
 >> +module_param_named(sysrq_key, sysrq_key, uint, 0644);
 >> +MODULE_PARM_DESC(sysrq_key, "The keycode to be used for sysrq");
 >> +
 >>  /*
 >>   * Translation of scancodes to keycodes. We set them on only the first
 >>   * keyboard in the list that accepts the scancode and keycode.
 >> @@ -1139,7 +1143,7 @@ static void kbd_keycode(unsigned int keycode, 
int down, int hw_raw)
 >>                  printk(KERN_WARNING "keyboard.c: can't emulate 
rawmode for keycode %d\n", keycode);
 >> 
 >>  #ifdef CONFIG_MAGIC_SYSRQ           /* Handle the SysRq Hack */
 >> -    if (keycode == KEY_SYSRQ && (sysrq_down || (down == 1 && 
sysrq_alt))) {
 >> +    if (keycode == sysrq_key && (sysrq_down || (down == 1 && 
sysrq_alt))) {
 >>          if (!sysrq_down) {
 >>              sysrq_down = down;
 >>              sysrq_alt_use = sysrq_alt;
 >>
 >
 > YAY! it works great.
 > tried with:
 > # echo 183 > /sys/module/keyboard/parameters/sysrq_key
 > but also keyboard.sys_rq=183 on the command line should work; I'll
 > discover that on next reboot.

Yes, please do verify.

 > thank you, Linus!

You're welcome.

 > (now that this has done in the proper way, is this patch going to be
 > merged in the tree?)


I'm certainly ok with it, but I guess it's more up to Dmitry. If he ack's
it, I can just commit it.

Dmitry? Any reason not to do this?

        Linus


-------------------------------------------------------------------------------

On 7/17/07, federico ferri <xaero@inwind.it> wrote:


 > Dmitry Torokhov ha scritto:
 > >> Dmitry? Any reason not to do this?
 > >>
 > >
 > > Recent kernels have the ability to remap keymap for USB keyboards via
 > > EVIOCSKEYCODE ioctl (we allowed 0adjusting keymaps on PS/2 keyboards
 > > for a long time). So instead of having the new parameter redefining
 > > SysRq keycode Frederico can remap one of the keys on his keyboard to
 > > generate KEY_SYSRQ. This way SysRq should still work if he plugs in
 > > another USB keyboard that has SysRq key or a PS/2 keyboard.
 >
 > would setkeycodes still just work for PS2 keyboards?
 > I upgraded to newer kbd-1.13 package (kernel 2.6.21), and while trying
 > to change sysrq keycode still I get the old error:
 >
 > KDSETKEYCODE: No such device
 > failed to set scancode 38b7 to keycode 84
 >
 > which I reported on gentoo a long time ago:
 > http://bugs.gentoo.org/show_bug.cgi?id=97388
 >
 > (it doesn't use EVIOCSKEYCODE)
 > maybe I'm not picking up the right program?
 >

EVIOCSKEYCODE support for HID (USB) went in in 2.6.22-rc1.

There is keyfuzz utility you can use to play with keymaps for a
particular device:

      http://0pointer.de/lennart/projects/keyfuzz/

-- 
Dmitry


