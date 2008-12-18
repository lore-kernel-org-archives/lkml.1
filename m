Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753578AbYLRLqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbYLRLqi (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYLRLq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:46:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33381 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYLRLq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:46:26 -0500
Date: Thu, 18 Dec 2008 11:44:27 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: David Howells <dhowells@redhat.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: PROC macro to annotate functions in assembly files
Message-ID: <20081218114427.GD10593@flint.arm.linux.org.uk>
Mail-Followup-To: Alexander van Heukelum <heukelum@mailshack.com>,
	David Howells <dhowells@redhat.com>,
	Alexander van Heukelum <heukelum@fastmail.fm>,
	linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm> <1636.1229511233@redhat.com> <20081217111213.GA8342@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217111213.GA8342@mailshack.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 12:12:14PM +0100, Alexander van Heukelum wrote:
> Yeah, assembly files contain some interesting nesting. In this
> particular case I think the solution is simple... Just use PROC
> and ENDPROC around the complete functions, and leave the explicit
> .global's for the additional entry points.

I'm sorry, that doesn't work in all cases.

On ARM with later toolchains, there's additional metadata associated with
every symbol, and it's beginning to matter getting this right.  That
metadata includes whether it's a function, and more importantly whether
the code pointed to by the symbol is Thumb or ARM.

This leads to:

ENTRY(__ashldi3)
ENTRY(__aeabi_llsl)

...

ENDPROC(__ashldi3)
ENDPROC(__aeabi_llsl)

and we want both of those symbols to have exactly the same attributes.

Merely adding a .globl for the second name doesn't do that.  It needs
.globl, .size, and .type.

So what you're actually talking about using your approach is enforcing
the pairing of the existing ENTRY/ENDPROC and open coding everything
else.

Forgive me if I think this is a backward step.  It certainly seems to
add some insane restrictions.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
