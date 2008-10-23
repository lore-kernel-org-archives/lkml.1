Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYJWO4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYJWO4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbYJWOzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:55:52 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:48805 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272AbYJWOzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:55:50 -0400
Subject: Re: High load in 2.6.27, NFS / rpcauth_lookup_credcache()?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Max Kellermann <max@duempel.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       harry@atmos.washington.edu
In-Reply-To: <20081023123628.GA18549@squirrel.roonstrasse.net>
References: <20081022091207.GA12996@squirrel.roonstrasse.net>
	 <20081023123628.GA18549@squirrel.roonstrasse.net>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 10:55:45 -0400
Message-Id: <1224773745.7625.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, MISSING_SUBJECT=0.001,NO_RECEIVED=-0.001, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 162A314DDE07892AE211AFCF3F4E2656B89EA00A
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 125 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 14:36 +0200, Max Kellermann wrote:
> On 2008/10/22 11:12, Max Kellermann <max@duempel.org> wrote:
> > after I was able to fix http://lkml.org/lkml/2008/10/17/147, the
> > server which was already upgraded to 2.6.27.2 still gets very high
> > load.  It is a web server with NFS file storage (NetApp), and while
> > the others in the cluster (kernel 2.6.25) have a load of 1-3, 2.6.27.2
> > gets 30-50.
> > 
> > I did an oprofile, with the following results (server just started,
> > load "only" 5-10):
> > 
> > 87593    56.1116  (no location information)   vmlinux
> > vmlinux                  rpcauth_lookup_credcache
> > 16037    10.2732  auth_generic.c:0            vmlinux
> > vmlinux                  generic_match
> > 6460      4.1382  (no location information)   php4
> > php4                     (no symbols)
> > 2478      1.5874  (no location information)   libc-2.7.so
> > libc-2.7.so              (no symbols)
> > [...]
> > 
> > We havn't configured any special authentication method.  It is a NFSv3
> > over UDP mount, but the kernel has NFSv4 and therefore KRB5 enabled.
> > 
> > Any ideas why rpcauth_lookup_credcache() goes overboard with CPU
> > usage?
> 
> I have bisected the problem: 98a8e323 is the result ("SUNRPC: Add a
> helper rpcauth_lookup_generic_cred()").  5c691044 is ok.
> 
> See the attached oprofile annotation data for both commits.  I guess
> that the function rpcauth_lookup_credcache() is waiting for a spinlock
> too often and too long.  Trond, any idea?

Can you add a '-v' to the rpc.gssd daemon startup line? I'd like to see
how often you are creating new gss contexts.

> Harry: added you to Cc because your problem sounds similar.

Harry's problem is should be unrelated. afaik, he is seeing a problem
with userland RPC code, not kernel rpc code.

Trond

