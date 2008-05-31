Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbYEaAFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbYEaAFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbYEaADS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:03:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:2348 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbYEaADQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=hHaBvdRBDyw8wm0TNtM3mzUk78nSfNShzq+iQFwgKbUVU6wp1FdQtiYz4Gdn7kNIsK3IV6OYmnE63Y2S0gt+vgE4GQXBAOvFMHXcTFfxuRTsaZFj4wcDB1Q2O1T9Oe5ffGKqyA8fwB7b1XPHpvWT3iJMDhU6VqmlSpCJ+fW2Cms=
Date: Sat, 31 May 2008 03:58:26 +0300
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Paul Moore <paul.moore@hp.com>, linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH BUGFIX -rc4] Smack: Respect 'unlabeled' netlabel mode
Message-ID: <20080531005826.GA6945@ubuntu>
References: <20080530233603.GA2994@ubuntu> <538684.41302.qm@web36603.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538684.41302.qm@web36603.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Casey,

On Fri, May 30, 2008 at 04:10:37PM -0700, Casey Schaufler wrote:
> 
> 
> To date the behavior of a Smack system running with nltype
> unlabeled has been carefully undefined. 
>

In the early days (before the 'Smack: unlabeled outgoing ambient packets'
patch - 4bc87e62), I used '$ echo unlabeled > /smack/nltype' in my startup 
scripts to avoid sending cipso-affected packets. When I upgraded this 
machine's kernel, I faced the -EPERM problem mentiond above. 

> The way you're defining
> it will result in a system in which only processes running with
> the ambient label will be able to use sockets, unless I'm reading
> the code incorrectly. 

I've tried to see the relation but failed, any help?

I'm noticing the opposite though, without defining nltype=unlabeled, 
we're forcing every smack-labeled process to send cipso-affected 
packets (and usually no machine around understands cipso).

_Assuming_ the concept is accepted, depending on the ambient label
may actually lead to a race condition though:

- A packet is set with the ambient label domain
- Ambient label changes
  - old ambient-label netlabel domain is deleted
  - new ambient-label is set
  - new ambient-label netlabel domain is created
- call netlabel_sock_setattr(), uses the old ambient label, leads
  to the -EPERM problem.
  -- Rare, but can happen

There are two possible solutions in my mind:

- Using a predefined netlabel domain to denote to unlabeled packets.
  Defect: May collide with a user chosen label and used to break security.
  Solution: Use a domain name that can't become a label (Hackery ?)

- I've tried first to use what was done before the 'Smack: unlabeled outgoing 
  ambient packets' patch, which honored nltype=unlabeled, but ignored netlabel
  completely:
  i.e.

  int rc = 0;
  if (secattr.flags != NETLBL_SECATTR_NONE)
       rc = netlbl_sock_setattr(sk, &secattr);
  return rc

  Paul, would this be right from a netlabel perspective ?

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

