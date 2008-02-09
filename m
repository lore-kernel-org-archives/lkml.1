Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbYBIEPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbYBIEPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 23:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYBIEPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 23:15:06 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:34752 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbYBIEPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 23:15:02 -0500
Date: Fri, 8 Feb 2008 20:12:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: torvalds@osdl.org, linux-input@vger.kernel.org, dtor@mail.ru,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keyboard notifier documentation
Message-Id: <20080208201253.46c068ed.randy.dunlap@oracle.com>
In-Reply-To: <20080209013322.GC4463@implementation>
References: <20080209013322.GC4463@implementation>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008 01:33:22 +0000 Samuel Thibault wrote:

> Document the keyboard notifier.
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> 
> --- /dev/null	2008-02-09 01:22:34.790011677 +0000
> +++ linux/Documentation/input/notifier.txt	2008-02-09 01:28:12.000000000 +0000
> @@ -0,0 +1,52 @@
> +Keyboard notifier
> +
> +One can use register_keyboard_notifier to get called back on keyboard
> +events (see kbd_keycode() function for details).  The passed structure is
> +keyboard_notifier_param:
> +
> +- 'vc' always provide the VC for which the keyboard event applies ;
> +- 'down' is 1 for a key press event, 0 for a key release ;
> +- 'shift' is the current modifier state, mask bit indexes are KG_* ;

No space before the ';' (3 times).

> +- 'value' depends on the type of event.
> +
> +- KBD_KEYCODE events are always sent before other events, value is the keycode.
> +- KBD_UNBOUND_KEYCODE events are sent if the keycode is not bound to a keysym.
> +  value is the keycode.
> +- KBD_UNICODE events are sent if the keycode -> keysym translation produced a
> +  unicode character. value is the unicode value.
> +- KBD_KEYSYM events are sent if the keycode -> keysym translation produced a
> +  non-unicode character. value is the keysym.
> +- KBD_POST_KEYSYM events are sent after the treatment of non-unicode keysyms.
> +  That permits to inspect the resulting LEDs for instance.

     That permits (some object word here, like: you, one, code, etc.) to
     inspect ...

> +
> +For each kind of event but the last, the callback may return NOTIFY_STOP in
> +order to "eat" the event: the notify loop is stopped and the keyboard event is
> +dropped.
> +
> +I a rough C snippet, we have:

   In a rough (?)

> +
> +kbd_keycode(keycode) {
> +	...
> +	params.value = keycode;
> +	if (notifier_call_chain(KBD_KEYCODE,&params) == NOTIFY_STOP)
> +	    || !bound) {
> +		notifier_call_chain(KBD_UNBOUND_KEYCODE,&params);
> +		return;
> +	}
> +
> +	if (unicode) {
> +		param.value = unicode;
> +		if (notifier_call_chain(KBD_UNICODE,&params) == NOTIFY_STOP)
> +			return;
> +		emit unicode;
> +		return;
> +	}
> +
> +	params.value = keysym;
> +	if (notifier_call_chain(KBD_KEYSYM,&params) == NOTIFY_STOP)
> +		return;
> +	apply keysym;
> +	notifier_call_chain(KBD_POST_KEYSYM,&params);
> +}
> +
> +NOTE: This notifier is usually called from interrupt context.
> --

---
~Randy
