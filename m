Return-Path: <linux-kernel-owner+w=401wt.eu-S1030459AbXEAMRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030459AbXEAMRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 08:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031181AbXEAMRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 08:17:11 -0400
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:52996 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030459AbXEAMRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 08:17:09 -0400
Message-ID: <46372FC3.6090807@moving-picture.com>
Date: Tue, 01 May 2007 13:17:07 +0100
From: James Pearson <james-p@moving-picture.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040524
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: X display shift with disabled console blanking
References: <46322E08.3040303@moving-picture.com>	 <1177727097.7568.6.camel@daplas>  <4635E810.80809@moving-picture.com> <1177969865.4372.23.camel@daplas>
In-Reply-To: <1177969865.4372.23.camel@daplas>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Disclaimer: This email and any attachments are confidential, may be legally
X-Disclaimer: privileged and intended solely for the use of addressee. If you
X-Disclaimer: are not the intended recipient of this message, any disclosure,
X-Disclaimer: copying, distribution or any action taken in reliance on it is
X-Disclaimer: strictly prohibited and may be unlawful. If you have received
X-Disclaimer: this message in error, please notify the sender and delete all
X-Disclaimer: copies from your system.
X-Disclaimer: 
X-Disclaimer: Email may be susceptible to data corruption, interception and
X-Disclaimer: unauthorised amendment, and we do not accept liability for any
X-Disclaimer: such corruption, interception or amendment or the consequences
X-Disclaimer: thereof.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino A. Daplas wrote:
> On Mon, 2007-04-30 at 13:58 +0100, James Pearson wrote:
> 
>>Antonino A. Daplas wrote:
>>
>>>On Fri, 2007-04-27 at 18:08 +0100, James Pearson wrote:
>>>
>>>
>>>>I have a problem whereby the X display 'shifts' to left when anything 
>>>>writes to /dev/console - where console screen blanking has been disabled 
>>>>i.e. doing something like:
>>>>
>>>>boot to run level 3
>>>>
>>>>If not root, then make sure /dev/console is writeable
>>>>
>>>>login and type:
>>>>
>>>>setterm -blank 0
>>>>
>>>>start X
>>>>
>>>>type into an xterm:
>>>>
>>>>echo "some random text" > /dev/console
>>>>(may have to repeat the echo above a few times)
>>>>
>>>>... and the whole X display jumps (and wraps) to the left
>>>>
>>>>I'm using a RHEL4 based distro with a vanilla 2.6.21 x86_64 kernel 
>>>>(although I've seen the problem with various x86_64 and i686 2.6.X kernels).
>>>>
>>>>I've seen this problem on a number of different nVidia cards - using 
>>>>the vesa driver (same problem occurs with nVidia's binary driver). I 
>>>>haven't tried using other makes of graphics cards.
>>>>
>>>>
>>>>OK, this may be a strange combination of disabling the text console 
>>>>blanking and running X, but something isn't right somewhere ...
>>>
>>>
>>>Yep, it's strange because I can't reproduce this. And the console write
>>>should not succeed if the current console is in KD_GRAPHICS mode, which
>>>is done by X (unless your version is different).
>>
>>I've just installed a vanilla CentOS 4.4 on an i686 SMP machine - with 
>>an nVidia Quadro4 980 XGL card.
>>
>>By default, this sets up X using the 'nv' driver (using RedHat's 
>>xorg-x11-6.8.2-1.EL.13.37).
>>
>>If I follow my 'recipe' above, then the screen shifts - note: it looks 
>>like you have to write several lines of text to /dev/console (at least 
>>30) to trigger the problem (e.g. run the echo to /dev/console in a loop) 
>>- also, I've found that switching to the console and back to X 
>>(Ctrl-Alt-F1 then Ctrl-Alt-F7) while this echo loop is running can force 
>>the shift to start ...
> 
> 
> I would understand that switching from text to graphics and vice versa
> can trigger display problems (it shouldn't, but it happens), but not
> while you are only echoing text to the system console in graphics mode.

It looks like switching from graphics -> text -> graphics definitely 
plays a part in the problem ... see below

>>This is with the RedHat based 2.6.9-42.ELsmp kernel - but I also get the 
>>problem with a vanilla 2.6.21 kernel.
>>
>>
>>>>Any ideas?
>>>
>>>
>>>I don't.  But, what is your current console?  Is it VGA, or framebuffer?
>>>Can you try doing this again in both VGA and vesafb?
>>
>>I'm not sure what the current console is - whatever is the default with 
>>RHEL4/CentOS4 - how do I select a different type of console?
>>
> 
> 
> dmesg | grep "Console:"

Console: colour VGA+ 80x25

>>>And this does not happen if there is no previous setterm -blank 0
>>>command?
>>
>>It doesn't happen if there is no previous 'setterm -blank 0' - so, 
>>arguably, this is the 'fix' ...
> 
> 
> Weird. The only thing I can think of is that console blanking is being
> triggered while the console is in graphics mode, which is not legal. 
> 
> How about 'setterm -blank 1', do an infinite echo loop and wait for at
> least 1 minute?

Setting the blank time to anything other than 0 is fine (no screen shift)

> Also, can you open drivers/char/vt.c and look for the function
> do_blank_screen?  You should have this particular segment.
> 
> Change this
> 
> if (console_blanked) {
> 	if (blank_state == blank_vesa_wait) {
> 		blank_state = blank_off;
> 		vc->vc_sw->con_blank(vc, vesa_blank_mode + 1, 0);
> 	}
> 	return;
> }
> 
> to
> 
> if (console_blanked && vc->vc_mode == KD_TEXT && !entering_gfx ) {
> 	if (blank_state == blank_vesa_wait) {
> 		blank_state = blank_off;
> 		vc->vc_sw->con_blank(vc, vesa_blank_mode + 1, 0);
> 	}
> 	return;
> }
> 
> Let me know if that even makes a difference.

Made no difference, although I can't see how it would as console_blanked 
is 0 when the problem happens.

It does indeed seem that the switching back and forth between text and 
graphics does appear to be part of the issue - in my previous testing I 
probably did do this (but didn't include this in my recipe above) - so 
here is a new 'recipe' that shows the problem (for me)

boot to run level 3

if not root, then make sure /dev/console is writeable

login and type:

setterm -blank 0

start X

type into an xterm:

while true; do echo "" > /dev/console; usleep 100000; done

while the above loop is running switch to the text console and back 
again (Ctrl-Alt-F1 then Ctrl-Alt-F7)

... and the screen will be shifting (and wrapping) to the left.

James Pearson

