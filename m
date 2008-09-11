Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbYIKSL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbYIKSL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYIKSLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:11:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59301 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbYIKSLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:11:18 -0400
Subject: Re: [PATCH 1/2] audit: fix NUL handling in untrusted strings
From: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
To: John Dennis <jdennis@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-audit <linux-audit@redhat.com>,
       viro@zeniv.linux.org.uk, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48C955C8.2000602@redhat.com>
References: <1221085418.2705.19.camel@amilo>
	 <1221143113.2992.9.camel@localhost.localdomain>
	 <48C955C8.2000602@redhat.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 11 Sep 2008 20:10:12 +0200
Message-Id: <1221156612.17533.14.camel@amilo>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Dennis píše v Čt 11. 09. 2008 v 13:30 -0400:
> Special processing with regards to the presence or absence of a null
> byte is one example of prohibited interpretation.
This is UNIX, "string" means "NUL-terminated string" (in fact the
presence of a NUL byte is the only way to reasonably detect binary
data). 

You're far more likely to encounter a fixed-length field with an
optional terminating NUL (like the old-style, 16-byte directory entries)
than an ASCII-compatible string that intentionally contains a NUL byte.

TTY input auditing was the only place where it makes a difference, all
other code was passing a string that was at least as long as the
specified size to audit_log_n_untrustedstring().

> It seems to me the problem is with audit_string_contains_control():
> 
> int audit_string_contains_control(const char *string, size_t len)
> {
>     const unsigned char *p;
>     for (p = string; p < (const unsigned char *)string + len && *p; p
> ++) {
>         if (*p == '"' || *p < 0x21 || *p > 0x7e)
>             return 1;
>     }
>     return 0;
> }
> 
> The problem is that it is passed a counted octet sequence but in some
> circumstances ignores the count. This occurs when *p == 0, the test
> for NULL should be removed. If that test is removed it will return the
> flag which indicates the string must be encoded differently to be
> conformant with the protocol.
Yes, that's possible - but then audit_log_n_untrustedstring() would be
more accurately called audit_log_n_ascii_like_binary_data().

Anyway, Eric/Al - if you prefer this solution, I can prepare an
alternative patch.

> As a side note I'm concerned there may be places in the user audit
> code which treat string data as null terminated (at least that is my
> recollection).
Yes, auditd adds a NUL terminator to the audit record, and then treats
it as a regular NUL-terminated string; if the audit record contains an
embedded NUL byte, the rest of the record is discarded by auditd. 
	Mirek

