Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbYLPNCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbYLPNCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 08:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYLPNCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 08:02:41 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:36929 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbYLPNCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 08:02:40 -0500
Subject: Re: High load in 2.6.27, NFS / rpcauth_lookup_credcache()?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Harry Edmon <harry@atmos.washington.edu>
Cc: Max Kellermann <max@duempel.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
In-Reply-To: <4946EBFA.60700@atmos.washington.edu>
References: <20081022091207.GA12996@squirrel.roonstrasse.net>
	 <20081023123628.GA18549@squirrel.roonstrasse.net>
	 <1224773745.7625.4.camel@localhost>  <4946EBFA.60700@atmos.washington.edu>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 08:02:33 -0500
Message-Id: <1229432553.7257.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 4C7923299EF1A6164E72D1B8C4FDCAB1B64691C7
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 264 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-15 at 15:44 -0800, Harry Edmon wrote:
> Trond Myklebust wrote:
> > On Thu, 2008-10-23 at 14:36 +0200, Max Kellermann wrote:
> >   
> >> On 2008/10/22 11:12, Max Kellermann <max@duempel.org> wrote:
> >>     
> >>> after I was able to fix http://lkml.org/lkml/2008/10/17/147, the
> >>> server which was already upgraded to 2.6.27.2 still gets very high
> >>> load.  It is a web server with NFS file storage (NetApp), and while
> >>> the others in the cluster (kernel 2.6.25) have a load of 1-3, 2.6.27.2
> >>> gets 30-50.
> >>>
> >>> I did an oprofile, with the following results (server just started,
> >>> load "only" 5-10):
> >>>
> >>> 87593    56.1116  (no location information)   vmlinux
> >>> vmlinux                  rpcauth_lookup_credcache
> >>> 16037    10.2732  auth_generic.c:0            vmlinux
> >>> vmlinux                  generic_match
> >>> 6460      4.1382  (no location information)   php4
> >>> php4                     (no symbols)
> >>> 2478      1.5874  (no location information)   libc-2.7.so
> >>> libc-2.7.so              (no symbols)
> >>> [...]
> >>>
> >>> We havn't configured any special authentication method.  It is a NFSv3
> >>> over UDP mount, but the kernel has NFSv4 and therefore KRB5 enabled.
> >>>
> >>> Any ideas why rpcauth_lookup_credcache() goes overboard with CPU
> >>> usage?
> >>>       
> >> I have bisected the problem: 98a8e323 is the result ("SUNRPC: Add a
> >> helper rpcauth_lookup_generic_cred()").  5c691044 is ok.
> >>
> >> See the attached oprofile annotation data for both commits.  I guess
> >> that the function rpcauth_lookup_credcache() is waiting for a spinlock
> >> too often and too long.  Trond, any idea?
> >>     
> >
> > Can you add a '-v' to the rpc.gssd daemon startup line? I'd like to see
> > how often you are creating new gss contexts.
> >
> >   
> >> Harry: added you to Cc because your problem sounds similar.
> >>     
> >
> > Harry's problem is should be unrelated. afaik, he is seeing a problem
> > with userland RPC code, not kernel rpc code.
> >
> > Trond
> >
> >   
> I am finally getting some time to look at my problem that I originally 
> reported in October (SUNRPC problem with 2.6.26 and beyond), and I am 
> seeing the same behavior as Max Kellermann when my machine slows as I 
> described earlier.  The system in question is currently running 
> 2.6.27.7.  Here is what I see when it is misbehaving:
> 
> samples  %        image name               app name                 
> symbol name
> 11380517 57.4191  sunrpc.ko                sunrpc                   
> rpcauth_lookup_credcache
> 3263657  16.4664  sunrpc.ko                sunrpc                   
> generic_match
> 1081287   5.4555  vmlinux                  vmlinux                  
> copy_user_generic_string
> 499407    2.5197  vmlinux                  vmlinux                  
> __posix_lock_file
> [...]
> 
> And here is what I see when I stop the programs that are chewing up all 
> the system time, and then starting them up again:
> 
> samples  %        image name               app name                 
> symbol name
> 6372650  21.7978  vmlinux                  vmlinux                  
> copy_user_generic_string
> 5401386  18.4755  sunrpc.ko                sunrpc                   
> rpcauth_lookup_credcache
> 3018753  10.3257  vmlinux                  vmlinux                  
> __posix_lock_file
> 1050095   3.5919  sunrpc.ko                sunrpc                   
> generic_match
> 
> 
> and I am not using Kerberos with NFSv4 (i.e. no rpc.gssd).  Did you ever 
> find a solution for this problem with rpcauth_lookup_credcache?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git&a=commitdiff&h=23918b03060f6e572168fdde1798a905679d2e06

Trond

