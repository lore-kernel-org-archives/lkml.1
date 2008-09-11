Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYIKUEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYIKUEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYIKUEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:04:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47495 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbYIKUEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:04:12 -0400
Subject: Re: [PATCH 1/2] audit: fix NUL handling in untrusted strings
From: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
To: John Dennis <jdennis@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-audit <linux-audit@redhat.com>,
       viro@zeniv.linux.org.uk, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48C975D5.3020603@redhat.com>
References: <1221085418.2705.19.camel@amilo>
	 <1221143113.2992.9.camel@localhost.localdomain>
	 <48C955C8.2000602@redhat.com> <1221156612.17533.14.camel@amilo>
	 <48C96D90.70608@redhat.com> <1221161260.17533.30.camel@amilo>
	 <48C975D5.3020603@redhat.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 11 Sep 2008 22:03:06 +0200
Message-Id: <1221163386.17533.52.camel@amilo>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Dennis píše v Čt 11. 09. 2008 v 15:47 -0400:
> Miloslav Trmač wrote: 
> > If the interface says "NUL-terminated string", any bytes after that are
> > not "actual data".
> Yes, that's correct. However, the function in question,
> audit_log_n_untrustedstring() is not an interface accepting a null
> terminated string, it accepts a count.
These options are not exclusive - see strnlen().
audit_log_n_untrustedstring(), as patched, follows that model exactly.

> > Yes, that's why it was wrong to use audit_*string() for TTY input data.
> > And the 2/2 patch fixes it - at the source of the problem, not in an
> > unrelated function that was incorrectly used.
> >   
> This is true, but it's only part of the problem, the string functions
> still need to be robust, even used inappropriately.
They need to do what they promise in the first place, only then can they
possibly do something useful with invalid input.  AUDIT_USER_TTY
messages, like all messages sent from user-space, are sent with a
trailing NUL.  The contents of the message are (more or less) trusted,
it is perfectly reasonable to stop at first NUL.
audit_log_n_untrustedstring(), as patched, does exactly what is needed -
the length parameter is used only to make unrelated kernel data does not
appear in the audit record. 

Now, given a function called fn(), either behavior (terminating at NUL,
or treating NUL as a control character) is valid, and AUDIT_USER_TTY
handling can be written for both behaviors of fn().  But given the
function is called ...untrustedstring, and "string" in C implies
NUL-terminated, I think it is more consistent to stop on NUL.
	Mirek

