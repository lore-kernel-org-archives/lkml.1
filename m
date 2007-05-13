Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbXEMAAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbXEMAAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 20:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbXEMAAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 20:00:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbXEMAAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 20:00:44 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] "volatile considered harmful", take 3
To: Satyam Sharma <satyam.sharma@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jonathan Corbet <corbet@lwn.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Johannes Stezenbach <js@linuxtv.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       jimmy bahuleyan <knight.camelot@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Reply-To: 7eggert@gmx.de
Date: Sun, 13 May 2007 02:00:06 +0200
References: <8jHg3-1T2-5@gated-at.bofh.it> <8jQt5-7As-3@gated-at.bofh.it> <8jSuQ-28J-21@gated-at.bofh.it> <8jT7y-39x-9@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Hn1VO-0001Gp-Ka@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/xfVA9fz/BrAH7X88p8SnlTMeusxp4Ul19QLG
 CZ7gm84tPRxalsiVcbXvBulkwm2qOYMj7fs25tETKFilr8Ta3i
 Ks128pRpT5OHPKoRAp90Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma <satyam.sharma@gmail.com> wrote:

> In fact you can't really say the same for
> volatile. We already assume the compiler _actually_ took some
> pains to stuff meaning into C's (lack of) definition of volatile and
> implement it -- but in what sense, nobody knows (the C standard
                                                   ^^^^^^^^^^^^^^
> doesn't, so what are we).
  ^^^^^^^
It does:

ISO/IEC 9899:1999 (E)

5.1.2.3 Program execution

5 The least requirements on a conforming implementation are:
 At sequence points, volatile objects are stable in the sense that previous
 accesses are complete and subsequent accesses have not yet occurred.

9 Alternatively, an implementation might perform various optimizations
 within each translation unit, such that the actual semantics would agree
 with the abstract semantics only when making function calls across
 translation unit boundaries. In such an implementation, at the time of each
 function entry and function return where the calling function and the
 called function are in different translation units, the values of all
 externally linked objects and of all objects accessible via pointers
 therein would agree with the abstract semantics. Furthermore, at the time
 of each such function entry the values of the parameters of the called
 function and of all objects accessible via pointers therein would agree
 with the abstract semantics. In this type of implementation, objects
 referred to by interrupt service routines activated by the signal function
 would require explicit specification of volatile storage, as well as other
 implementation-defined restrictions.


6.7.3 Type qualifiers

6 An object that has volatile-qualified type may be modified in ways unknown
 to the implementation or have other unknown side effects. Therefore any
 expression referring to such an object shall be evaluated strictly according
 to the rules of the abstract machine, as described in 5.1.2.3. Furthermore,
 at every sequence point the value last stored in the object shall agree with
 that prescribed by the abstract machine, except as modified by the unknown
 factors mentioned previously.114) What constitutes an access to an object
 that has volatile-qualified type is implementation-defined.

<snip>

It does not guarantee ordering or consistency beyond the scope of the
assembler layer, especially the CPU or other hardware may be free to cache
or reorder load/stores to these volatile objects (see e.g. MTRR), which is
why you'll usurally want to use something completely different. If you know
an object to not be modified from outside the scope of the C state machine
and it does not have relevant side effects, you can however use volatile
(likely on an atomic value).

I think you should say something like:

1) Don't use volatile
2) Read memory-barriers.txt carefully!
3) If you still use volatile, explain
  a) Why it's nescensary
  b) Why it's enough (see (2))
 to specify volatile on that object. Be sure to consider hardware cache and
 reordering, as well as prohibited optimizations on volatile access and on
 functions possibly doing volatile access.
-- 
Top 100 things you don't want the sysadmin to say:
14. Any more trouble from you and your account gets moved to the 750

Friﬂ, Spammer: rg@vieMYD.7eggert.dyndns.org vrl1v@sl.7eggert.dyndns.org
