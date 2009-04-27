Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbZD0IJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbZD0IJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbZD0IJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:09:17 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44201 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755190AbZD0IJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:09:15 -0400
X-Sasl-enc: DOEeSsEgtpoZ52EQzMONde1rn7KICrjH6bnkQJy0fWam 1240819753
Message-ID: <49F5682F.20300@ladisch.de>
Date: Mon, 27 Apr 2009 10:09:19 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: NLS: utf8 conversions
References: <Pine.LNX.4.44L0.0904241534110.4531-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0904241534110.4531-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> Although nobody seems to have made a big deal about it, the conversions
> between utf8 and utf16 done by fs/nls/nls_base.c are wrong in a couple
> of important respects:
> 
> 	They don't handle Unicode code points larger than U+FFFF.
> 
> 	They don't detect invalid values, in particular, surrogate
> 	code points.
> 
> The problems stem from the fact the characters at issue can't be
> represented by a single 16-bit wchar_t.  But that's no excuse for
> performing an incorrect conversion to or from utf16.
> 
> Are there any definite thoughts on how this should be handled?  I don't 
> see any way for the single-character conversion routines (utf8_mbtowc 
> and utf8_wctomb) to come to grips with these issues, except perhaps for 
> returning an error when a character would be invalid or too big to fit 
> in 16 bits.
> 
> The string-oriented routines (utf8_mbstowcs and utf8_wcstombs) could be 
> adapted to deal with these issues properly.
> 
> Any comments or suggestions for other approaches?

The single-character utf8_* routines in nls_base.c are just special
cases of the NLS API for the UTF-8 encoding; the string-oriented
routines, as far as I can see, are actually only used to do conversions
between UTF-8 and UTF-16, not wchar_t, so they probably should be
renamed.

As for the NLS API itself: If we want to be able to handle code points
larger than U+FFFF, the obvious answer is to make wchar_t a 32-bit type.
This should not be too large a problem because the FS NLS API is
designed so that wchar_t is only used for temporary values, i.e.,
characters are converted from some on-disk encoding to wchar_t, then
from wchar_t to some I/O encoding (usually UTF-8); and the conversions
are done one code point at a time.

The file systems that use some form of UTF-16 (VFAT, NTFS, CIFS, UDF,
etc.) use the NLS API in a different way: they treat the individual
UTF-16 values as wchar_t values and do only the conversion from wchar_t
to the I/O encoding.  Here we'd need to introduce an additional
conversion step between UTF-16 and wchar_t, i.e., treat UTF-16 like any
other multibyte encoding.


Best regards,
Clemens
