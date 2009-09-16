Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZIPIdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZIPIdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZIPIdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:33:16 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45490 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZIPIdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:33:14 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] DRBD for 2.6.32
Date: Wed, 16 Sep 2009 10:33:14 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, drbd-dev@lists.linbit.com,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <200909151645.14256.philipp.reisner@linbit.com> <20090915231931.GB7636@infradead.org>
In-Reply-To: <20090915231931.GB7636@infradead.org>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909161033.14773.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 September 2009 01:19:31 Christoph Hellwig wrote:
> On Tue, Sep 15, 2009 at 04:45:13PM +0200, Philipp Reisner wrote:
> > Hi Linus,
> >
> > Please pull
> > git://git.drbd.org/linux-2.6-drbd.git drbd
> >
> > DRBD is a shared-nothing, replicated block device. It is designed to
> > serve as a building block for high availability clusters and
> > in this context, is a "drop-in" replacement for shared storage.
> >
> > It has been discussed and reviewed on the list since March,
> > and Andrew has asked us to send a pull request for 2.6.32-rc1.
>
> The last thing we need is another bloody raid-reimplementation, coupled
> with a propritary on the wire protocol.  NACK as far as I am concerned.

Hi Christoph,

Unfortunately we have not been CCing you on our first posts and discussion,
but only on our most recent one. So I will repeat the key points of the 
discussion.

DRBD does not want to be a local RAID, it is heavily tied to its domain,
and offers significant advantages there. -- Things that can not be achieved
by combining MD+NBD or MD+iSCSI:

 * When DRBD is used over small bandwidth links and one has to do a resync,
   DRBD can do a "checksum based resync", similar in the way rsync works.
   A whole data block gets transmitted only if the checksums of that 
   block differ.

   Again, this is something you can not do with an iSCSI transport.

 * DRBD can do online verify of the mirror, again, using checksums to
   reduce network traffic.

   How do you want to achieve that using an iSCSI transport ?

 * Dual primary mode with write conflict detection and resolution.

     One need to point out that this should never happen, as long 
     as the DLM used does not fail. But if it ever happens, you
     want you mirroring solution to keep the two sides of your
     mirror in sync.

     This is something that can not be done in the MD+MBD or MD+iSCSI
     model, because the block transport does not have a concept for that.

That said to the conceptual reasons for DRBD, now for some other reasons:

 * UUIDs that identify data generations, dirty bitmap, bitmap merging.

    Think of a two node HA cluster. Node A is active ('primary' in DRBD
    speak) has the filesystem mounted and the application running. Node B is
    in standby mode ('secondary' in DRBD speak).

    We loose network connectivity, the primary node continues to run, the
    secondary no longer gets updates.

    Then we have a complete power failure, both nodes are down. Then they
    power up the data center again, but at first they get only the power
    circuit of node B up and running again.

    Should node B offer the service right now ?
      ( DRBD has configurable policies for that )

    Later on they manage to get node A up and running again, now lets assume
    node B was chosen to be the new primary node. What needs to be done ?

    Modifications on B since it became primary needs to be resynced to A.
    Modifications on A sind it lost contact to B needs to be taken out.

    DRBD does that.

    How do you fit that into a RAID1+NBD model ? NBD is just a block
    transport, it does not offer the ability to exchange dirty bitmaps or
    data generation identifiers, nor does the RAID1 code has a concept of
    that.

 * There is a whole eco-system of integration work of DRBD with various
   cluster managers (open source, and closed ones).
   There is no open source cluster manager integration available of the
   MD+NBD idea.

 * DRBD has a massive user base. It is included in SLES, Debian and Ubuntu,
   (and probably some other distributions as well).

Please also have a look at the lists' archive, the main discussion was 
started on 2009-05-15.

-Phil
