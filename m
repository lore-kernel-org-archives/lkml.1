Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbYIKO0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbYIKO0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYIKO0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:26:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53886 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbYIKO0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:26:18 -0400
Subject: Re: [PATCH 1/2] audit: fix NUL handling in untrusted strings
From: Eric Paris <eparis@redhat.com>
To: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-audit <linux-audit@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1221085418.2705.19.camel@amilo>
References: <1221085418.2705.19.camel@amilo>
Content-Type: text/plain; charset=utf-8
Date: Thu, 11 Sep 2008 10:25:13 -0400
Message-Id: <1221143113.2992.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-11 at 00:23 +0200, Miloslav Trmač wrote:
> From: Miloslav Trmac <mitr@redhat.com>
> 
> audit_string_contains_control() stops checking at the first NUL byte.
> If audit_string_contains_control() returns FALSE,
> audit_log_n_untrustedstring() submits the complete string - including
> the NUL byte and all following bytes, up to the specified maximum length
> - to audit_log_n_string(), which copies the data unchanged into the
> audit record.
> 
> The audit record can thus contain a NUL byte (and some unchecked data
> after that).  Because the user-space audit daemon treats audit records
> as NUL-terminated strings, an untrusted string that is shorter than the
> specified maximum length effectively terminates the audit record.
> 
> This patch modifies audit_log_n_untrustedstring() to only log the data
> before the first NUL byte, if any.

I'm going to have to say NAK on this patch.

It's still not right looking at the other user,
audit_log_single_execve_arg().  An execve arg with a NULL could loose
the stuff after the NULL (not break the record like audit_tty) since the
execve uses %s rather than calling trusted string.

How about we change the meaning of audit_string_contains_control()
return values?  If it returns positive that is the number of bytes in a
legitimate string up to the first null.  -1 means it is hex.  That
eliminates your code duplication and allows us to do the right thing in
both the generic untrusted_string code and the execve code.....

-Eric

