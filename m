Return-Path: <linux-kernel-owner+w=401wt.eu-S1759682AbZAGSfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbZAGSfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbZAGSfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:35:17 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:1785 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbZAGSfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:35:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=nXKC0zn9vqhhl890rzu3CcgtPq9xf3DY5mxRRPtEmmvFfv6JjoeQCUX8CKwwqGPiFT
         OyVLpB8GCGqFgbEhGgV1ZViR4hr4MWzNiH9zx1yTOOF5lDtRCr2DaKMG91+Y0QPoBMOP
         Rbie1WtVGD3o5URpWBOK5e1P8WPxx/jyiPyaM=
Message-ID: <c6d9bea0901071035p1b8b4fc1u49bc7bb7c89782a@mail.gmail.com>
Date: Wed, 7 Jan 2009 13:35:13 -0500
From: "C. Scott Ananian" <cscott@laptop.org>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [PATCH] Security: Implement and document RLIMIT_NETWORK.
Cc: "Michael Stone" <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20090107114703.GB28161@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231307334-9542-1-git-send-email-michael@laptop.org>
	 <1231307334-9542-2-git-send-email-michael@laptop.org>
	 <20090107114703.GB28161@ioremap.net>
X-Google-Sender-Auth: 3da61b14c2ea6ffe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 6:47 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
>> +This facility is particularly attractive to security platforms like OLPC
>> +Bitfrost [2] and to isolation programs like Rainbow [3] and Plash [4] because:
>> +  * it integrates well with standard techniques for writing privilege-separated
>> +    Unix programs
>> +  * it's available to unprivileged programs

> It isn't, since it can not set rlimit, and if it can, it still can drop it.

Privilege dropping is voluntary, in the same way that a setuid root
program can voluntarily drop root permissions after it has finished
using them.  (Standard example: apache starts as root to open port 80,
and then drops root by changing uid to www or nobody before it
actually processes requests.)

If I understand correctly, rlimit has both 'hard' and 'soft' limits.
An unpriviledged process can change its soft limit at will, up to the
hard limit, but can only *irrevocably lower* its hard limit. (man 2
setrlimit)

I haven't reviewed the patch to confirm this, but this is how I would
expect RLIMIT_NETWORK functions.  A trusted process like inetd (say)
would accept a network connection and create a file handle.  It would
then fork, drop the hard and soft RLIMIT_NETWORK to 0, and then exec
the untrusted client program.  This would allow the untrusted program
to use the 'trusted' network resource via the open file handle, but
prevent it from (say) leaking sensitive transaction data by making
further connections to some other network resource.  (There are better
use cases than inetd, of course.)

According to man 2 setrlimit, "A child process created via fork(2)
inherits its parent's resource limits.  Resource limits are preserved
across execve(2).".
 --scott

-- 
                         ( http://cscott.net/ )
