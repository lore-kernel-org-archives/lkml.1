Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbYJNSPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbYJNSPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 14:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYJNSO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 14:14:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34595 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYJNSO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 14:14:59 -0400
Date: Tue, 14 Oct 2008 13:44:55 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Alexander V. Lukyanov" <lav@netis.ru>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [REVERT Request] VT Breakage (fwd)
In-Reply-To: <alpine.LFD.2.00.0810141001330.3288@nehalem.linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0810141323220.26164@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.2.00.0810141001330.3288@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-10-14 13:03, Linus Torvalds wrote:
>
>Alexander, is your patch the same as mine, or something else?

Something else, you reverted more.

>@@ -400,7 +400,7 @@ static u8 build_attr(struct vc_data *vc, u8 _color, u8 _intensity, u8 _blink,
>  *  Bit 7   : blink
>  */
> 	{
>-	u8 a = _color;
>+	u8 a = vc->vc_color;
> 	if (!vc->vc_can_do_color)
> 		return _intensity |
> 		       (_italic ? 2 : 0) |

This hunk for example was not reverted in Alexander's patch. I think it 
should remain at reading "a = _color", because the caller(s) can just be 
updated to use pass in vc->vc_color for _color. Actually, the callers 
already do just this.

>Jan, if different, can you test this?

>@@ -1890,9 +1883,9 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
> 			scr_memsetw((unsigned short *) (vc->vc_origin +
> 							vc->vc_size_row *
> 							(b - count)),
>-				    vc->vc_scrl_erase_char,
>+				    vc->vc_video_erase_char,
> 				    vc->vc_size_row * count);
>-			ret = 1;
>+			return 1;
> 			break;
> 
> 		case SCROLL_WRAP_MOVE:

His patch remained at "ret = 1". It should not cause any difference 
besides potential compiler optimizations --- control would just trickle 
through all the break;s and then return shortly with 'ret' anyway):

>-	vc->vc_video_erase_char = saved_ec;
>-	return ret;
>+	return 0;
> }

As such, your patch is producing the same net effect
for me as Alexander's.

As for you being unable to reproduce it, it is imperial to test the 
linux vt-on-a-VGA. You cannot cheat using UML-in-a-xterm (that was a bit 
of a surprise even to me, so I let you know), serial console or anything 
like that.

The expected output is http://tinyurl.com/3zs3dk
(color erased only on scroll; linewraps causing no scroll don't 
colorflood); behavior matches xterm.

