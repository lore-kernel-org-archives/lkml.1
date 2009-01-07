Return-Path: <linux-kernel-owner+w=401wt.eu-S1761587AbZAGVIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761587AbZAGVIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761221AbZAGVIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:08:00 -0500
Received: from lists.laptop.org ([18.85.2.145]:49136 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761219AbZAGVH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:07:59 -0500
Date: Wed, 7 Jan 2009 16:07:58 -0500
From: Michael Stone <michael@laptop.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Security: Implement and document RLIMIT_NETWORK.
Message-ID: <20090107210758.GH3164@didacte.laptop.org>
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <1231307334-9542-2-git-send-email-michael@laptop.org> <20090107114703.GB28161@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090107114703.GB28161@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy,

First, thanks very much for all your comments and questions.

On Wed, Jan 07, 2009 at 02:47:03PM +0300, Evgeniy Polyakov wrote:

>> +  * it's available to unprivileged programs
>> +
>
>It isn't, since it can not set rlimit, and if it can, it still can drop
>it.

Some sample code will probably clarify the use of my patch: 

   http://dev.laptop.org/git?p=users/mstone/test-rlimit-network;a=blob;f=disable_network.c;hb=HEAD

This C code describes a 'disable_network' exec-chain script which, when run as
any user, irrevocably disables network access as described in my previous
emails. 

As you can see, processes start with full access to the 'network' resource and
may, at any time, irrevocably (modulo CAP_SYS_RESOURCE) limit their and their
future children's access to this resource by lowering both their soft and hard
limits to 0.

>Your code does not cover sendpage() interface (aka splice() and
>sendfile()) 

Nor should it. Applications should continue to be able to send data on any
sockets where were already connected and should be able to accept new
connections on sockets which were already bound.

I have done some primitive testing to ensure that the patch implements this
functionality by means of the test utilities provided here:

  http://dev.laptop.org/git?p=users/mstone/test-rlimit-network;a=tree

Can you confirm my results?

> and with your approach application will suddenly stops sending data even into
> old sockets, but will be able to receive it from anywhere. Is it intentional?

Why do you think this would happen? 

(My test results, e.g. via
    http://dev.laptop.org/git?p=users/mstone/test-rlimit-network;a=blob;f=positive_localhost_tcp;hb=HEAD
  show otherwise.)

>The same goal can be achieved with 'owner' iptables match module btw.

As Rémi explained, the iptables 'owner' match module solves a different
problem.

> but when parent sets the rlimit it is not updated in the childs.

This is by design. Limiting my shell's networking privileges in preparation for
running an untrusted command should not limit the privileges of programs that I
have previously started running from the same shell process.

Regards,

Michael

P.S. - Rémi, Scott: Thanks very much for your supportive comments.

