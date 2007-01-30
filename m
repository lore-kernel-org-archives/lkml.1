Return-Path: <linux-kernel-owner+w=401wt.eu-S965589AbXA3PWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965589AbXA3PWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965593AbXA3PWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:22:33 -0500
Received: from mail.gmx.net ([213.165.64.20]:44750 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965589AbXA3PWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:22:33 -0500
X-Authenticated: #14842415
From: Alessandro Di Marco <dmr@gmx.it>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
References: <873b61cf1v.fsf@gmx.it> <20070126171536.GB964@elf.ucw.cz>
	<878xfpoeom.fsf@gmx.it> <20070127174525.GA4787@ucw.cz>
	<20070127192034.GA17652@suse.cz> <874pqanddd.fsf@gmx.it>
	<20070129222833.GB17330@elf.ucw.cz> <87odoho3pb.fsf@gmx.it>
	<20070130094205.GA2888@suse.cz> <87ireowv7d.fsf@gmx.it>
	<20070130130936.GB4242@suse.cz>
Date: Tue, 30 Jan 2007 16:22:29 +0100
Message-ID: <877iv4letm.fsf@gmx.it>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vojtech Pavlik <vojtech@suse.cz> writes:

   > Mine problem here is that the input device doesn't care about suspend/resume
   > cycles (it is a straight char driver), probably because it doesn't need to (so
   > far.) Low-level drivers (kbd & co) on the contrary are all bus or platform
   > drivers, hooking directly into suspend/resume callbacks.
   > 
   > Do you mean that I should back-propagate a suspend/resume event from the
   > low-level drivers to the input one?

   Yes, but not as a callback, but instead as an input event. 

Hum. Usually I'm not so dumb, really.

Problem) I need to know when the system goes to sleep in
drivers/input/input.c. For example, as a consequence of 'echo mem
>/sys/power/state'.

Solution 1) My ideal input layer model would be:

               | SUBSYSTEM INPUT DEVICE* |
                   ^  ^      ^       ^
            +------+  |      +----+  +------+ events 
            |         |           |         |
        |KEYBOARD| |MOUSE | |TOUCHSCREEN| |MISC  |
        |DEVICE  | |DEVICE| |DEVICE     | |DEVICE|

               | SUBSYSTEM INPUT DEVICE* |
                   |  |      |       |
            +------+  |      +----+  +------+ suspend()/resume() callbacks
            v         v           v         v
        |KEYBOARD| |MOUSE | |TOUCHSCREEN| |MISC  |
        |DEVICE  | |DEVICE| |DEVICE     | |DEVICE|

Solution 2) On the contrary, you are suggesting to do this:

               |          INPUT DEVICE          |
                   ^     ^      ^           ^
            +------+     |      +----+      +------+ events plus
            |            |           |             | suspend/resume
        |KEYBOARD | |MOUSE    | |TOUCHSCREEN| |MISC      |
        |SUBSYSTEM| |SUBSYSTEM| |SUBSYSTEM  | |SUBSYSTEM |
        |DEVICE*  | |DEVICE*  | |DEVICE*    | |DEVICE*   |

Right?

* or whatever provides suspend/resume callbacks

-- 
>From their experience or from the recorded experience of others (history), men
learn only what their passions and their metaphysical prejudices allow them to
learn. - Aldous Huxley
