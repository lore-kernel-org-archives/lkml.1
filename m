Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbYIKOoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbYIKOoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYIKOo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:44:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35841 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYIKOo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:44:28 -0400
Subject: Re: [PATCH 1/2] audit: fix NUL handling in untrusted strings
From: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-audit <linux-audit@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1221143113.2992.9.camel@localhost.localdomain>
References: <1221085418.2705.19.camel@amilo>
	 <1221143113.2992.9.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Thu, 11 Sep 2008 16:43:19 +0200
Message-Id: <1221144199.3033.47.camel@amilo>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review.
Eric Paris píše v Čt 11. 09. 2008 v 10:25 -0400:
> On Thu, 2008-09-11 at 00:23 +0200, Miloslav Trmač wrote:
> > This patch modifies audit_log_n_untrustedstring() to only log the data
> > before the first NUL byte, if any.
> 
> I'm going to have to say NAK on this patch.
> 
> It's still not right looking at the other user,
> audit_log_single_execve_arg().  An execve arg with a NULL could loose
> the stuff after the NULL (not break the record like audit_tty) since the
> execve uses %s rather than calling trusted string.
execve() arguments are NUL-terminated strings:
audit_log_single_execve_arg() starts with
	len_left = len = strnlen_user(p, MAX_ARG_STRLEN) - 1;
and the two cycles handle chunks in the first "len" bytes of "p".
audit_log_single_execve_arg() never touches any bytes after the first
NUL.

So, when audit_log_single_execve_arg() calls
audit_string_contains_control(buf, to_send), strlen(buf) == to_send and
the patch does not change anything.

> How about we change the meaning of audit_string_contains_control()
> return values?  If it returns positive that is the number of bytes in a
> legitimate string up to the first null.  -1 means it is hex.
That is possible, although the return value convention is somewhat
complex.  Anyway, no change to the semantics of
audit_string_contains_control() is necessary for execve() argument
logging.
	Mirek

