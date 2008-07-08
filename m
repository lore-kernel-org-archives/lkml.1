Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbYGHVdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbYGHVdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 17:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYGHVdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 17:33:08 -0400
Received: from swan.nt.tuwien.ac.at ([128.131.67.158]:48879 "EHLO
	swan.nt.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbYGHVdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 17:33:06 -0400
Date: Tue, 8 Jul 2008 23:33:02 +0200
From: Thomas Zeitlhofer <tzeitlho+lkml@nt.tuwien.ac.at>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: IPSEC in 2.6.25 causes stalled connections
Message-ID: <20080708213302.GA28842@swan.nt.tuwien.ac.at>
References: <20080608010858.GA8877@swan.nt.tuwien.ac.at> <E1K8TuP-0002Qd-00@gondolin.me.apana.org.au> <20080618004544.GA25439@swan.nt.tuwien.ac.at> <20080708080742.GA25027@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708080742.GA25027@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 04:07:42PM +0800, Herbert Xu wrote:
> Sorry for the late response.
> 
> On Wed, Jun 18, 2008 at 02:45:44AM +0200, Thomas Zeitlhofer wrote:
> > 
> > src 192.168.69.2 dst 192.168.69.1
> >         proto esp spi 0xc885bfdd(3364208605) reqid 3(0x00000003) mode tunnel
> >         replay-window 32 seq 0x00000000 flag  (0x00000000)
> >         auth hmac(sha1) 0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX (160 bits)
> >         enc cbc(aes) 0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX (256 bits)
> >         sel src 0.0.0.0/0 dst 0.0.0.0/0 uid 0
> >         lifetime config:
> >           limit: soft (INF)(bytes), hard (INF)(bytes)
> >           limit: soft (INF)(packets), hard (INF)(packets)
> >           expire add: soft 3056(sec), hard 3600(sec)
> >           expire use: soft 0(sec), hard 0(sec)
> >         lifetime current:
> >           2964393536(bytes), 2063237(packets)
> >           add 2008-06-18 01:19:47 use 2008-06-18 01:19:48
> 
> Your SA has been marked for expiry at 02:19:47.  So what time
> did you take this snapshot? Hmm, we really should make the SA
> state available to ip x s so that I don't have to ask :)

The output above has been produced after I observed a stalled
connection - I guess some time afterwards. Anyway, I took care that the
lifetime of the SA is long enough (1 hour) to avoid eventual problems
while rekeying. 

> What IPsec daemon are you using to manage SA rekeying?

I tried it with racoon and strongswan and both show the same behavior.

Here are some additional observations:

-) Changing the crypto algorithms from aes/sha1 to 3des/md5 makes no
   difference.

-) It does not matter if tunnel or transport mode is used.

-) The problem is already present in 2.6.25-rc1 and still found in
   2.6.25.10 and also in 2.6.26-rc9. There is no problem with
   2.6.24[.x].

-) I manged to reproduce it also with kvm-based (x86_64, virtio) and
   vmware-based (i386) virtual machines.

-) The easiest way to reproduce the effect is as follows:

   (1) Use two (virtual) machines kvm1 and kvm2 and configure an IPSEC
       connection between them.
   (2) Watch the interface of one machine with nload or a similar tool
   (3) kvm1:~# cat /dev/zero | netcat -l -p 12345 &
   (4) kvm2:~# cat /dev/zero | netcat -l -p 12345 &
   (5) kvm1:~# netcat kvm2 12345 >/dev/null

   According to (2), the packet flow from kvm2 to kvm1 can bee watched
   now and everything works fine.

   (6) kvm2:~# netcat kvm1 12345 >/dev/null

   Now, the additional packet flow from kvm1 to kvm2 can been watched
   only for a couple of seconds and then the connection (6) stalls.
   Typically, the other connection (5) does not stall and keeps on
   working. But these results may vary, so sometimes both connections
   stall and sometimes connection (5) stalls and connection (6) works
   fine.

   It seems that once a connection is stalled it does not even recover
   temporarily - strace on the listening netcat process shows that the
   write call to the socket blocks until it times out.

   Without IPSEC, steps (2) to (6) result in two packet flows that keep
   on running without problems.

--
Thomas
