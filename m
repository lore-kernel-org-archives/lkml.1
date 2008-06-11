Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbYFKPKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbYFKPKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYFKPKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:10:31 -0400
Received: from styx.suse.cz ([82.119.242.94]:53024 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760088AbYFKPKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:10:30 -0400
Date: Wed, 11 Jun 2008 17:10:28 +0200
From: Jiri Bohac <jbohac@suse.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Jiri Bohac <jbohac@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console keyboard mapping broken by 04c71976
Message-ID: <20080611151028.GB11462@midget.suse.cz>
References: <20080611134837.GA11462@midget.suse.cz> <20080611140304.GM4244@implementation.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611140304.GM4244@implementation.uk.xensource.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 03:03:04PM +0100, Samuel Thibault wrote:
> Err, at quick look it looks to me rather like a bug kbd, which doesn't
> cope with the console being in unicode mode.  Which distribution are you
> using?
> 
> In unicode mode, k_self is really meant to hold unicode values (there is
> no other way to provide an arbitrary unicode value in keyboard maps),
> and thus kbd should translate KT_LETTER's value from the map file's
> encoding (set by the charset directive) to unicode.

I am actually hunting down a bug this causes in openSUSE. We use
kbd-1.12. kbd does not translate anything to unicode - there is
no space for that in the 8 bits the keycode uses for the value.
The kernel needs to take care for the conversion.

I'll demonstrate the problem on tracing kbd_keycode() in
drivers/char/keyboard.c when the key "2" (keycode 3) is pressed.
The expected result is the letter letter "e" with a caron [CARON]
accent, code 0xec in iso-8859-2 [88592].

The keysym for this key in the Czech keyboard is set to 0xbec
by a call to KDSKBENT, which stores it as 0xfbec in the map.

	...
	type = KTYP(keysym);		// 0xfb
	...
	type -= 0xf0;			// 0xb
        if (type == KT_LETTER) {	// true
                type = KT_LATIN;	// 0
 
	...
        (*k_handler[type])(vc, keysym & 0xff, !down); 
		// calls k_self, note there is really no space for a 
		// full unicode representation ;-)

So, we need to perform the conversion in k_self (or later).  Your
patch removed it from k_unicode, but only does it in k_self when
the keyboard mode is not VC_UNICODE.

[CARON]: http://en.wikipedia.org/wiki/Caron
[88592]: http://en.wikipedia.org/wiki/Iso-8859-2

Regards,

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

