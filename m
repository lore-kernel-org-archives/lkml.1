Return-Path: <linux-kernel-owner+w=401wt.eu-S1765443AbYBNURf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765443AbYBNURf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbYBNUR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:17:26 -0500
Received: from qb-out-0506.google.com ([72.14.204.237]:45394 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbYBNURZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:17:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JMy8kKm38KAUsVn3W/jMdYWPEylolJb7OE/f3e/rP/lV1zTd+EgtJ9nw+GQC9He/j9yR6DthZDiEdCwPJZH4LzALL0PTIql9PjSByo+RsjcAQLB4aK8ZYfi5KPAOBSj7+xSCn/NNuhpbNFR3PnzFVr+vUCIeX28p20N80iI63gA=
Message-ID: <469958e00802141217i3a3d16a1k1232d69b8ba54471@mail.gmail.com>
Date: Thu, 14 Feb 2008 12:17:21 -0800
From: "Caitlin Bestler" <caitlin.bestler@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [ofa-general] Re: Demand paging for memory regions
Cc: "Steve Wise" <swise@opengridcomputing.com>,
       "Rik van Riel" <riel@redhat.com>, steiner@sgi.com,
       "Andrea Arcangeli" <andrea@qumranet.com>, a.p.zijlstra@chello.nl,
       izike@qumranet.com, "Roland Dreier" <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, "Robin Holt" <holt@sgi.com>,
       general@lists.openfabrics.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0802141137140.500@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
	 <20080209075556.63062452@bree.surriel.com>
	 <Pine.LNX.4.64.0802091345490.12965@schroedinger.engr.sgi.com>
	 <ada3arzxgkz.fsf_-_@cisco.com>
	 <47B2174E.5000708@opengridcomputing.com>
	 <Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com>
	 <adazlu5vlub.fsf@cisco.com>
	 <8A71B368A89016469F72CD08050AD334026D5C23@maui.asicdesigners.com>
	 <47B45994.7010805@opengridcomputing.com>
	 <Pine.LNX.4.64.0802141137140.500@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 11:39 AM, Christoph Lameter <clameter@sgi.com> wrote:
> On Thu, 14 Feb 2008, Steve Wise wrote:
>
>  > Note that for T3, this involves suspending _all_ rdma connections that are in
>  > the same PD as the MR being remapped.  This is because the driver doesn't know
>  > who the application advertised the rkey/stag to.  So without that knowledge,
>  > all connections that _might_ rdma into the MR must be suspended.  If the MR
>  > was only setup for local access, then the driver could track the connections
>  > with references to the MR and only quiesce those connections.
>  >
>  > Point being, it will stop probably all connections that an application is
>  > using (assuming the application uses a single PD).
>
>  Right but if the system starts reclaiming pages of the application then we
>  have a memory shortage. So the user should address that by not running
>  other apps concurrently. The stopping of all connections is still better
>  than the VM getting into major trouble. And the stopping of connections in
>  order to move the process memory into a more advantageous memory location
>  (f.e. using page migration) or stopping of connections in order to be able
>  to move the process memory out of a range of failing memory is certainly
>  good.
>

In that spirit, there are two important aspects of a suspend/resume API that
would enable the memory manager to solve problems most effectively:

1) The device should be allowed flexibility to extend the scope of the suspend
    to what it is capable of implementing -- rather than being forced
to say that
    it does not support suspend/;resume merely because it does so at a different
    granularity.

2) It is very important that users of this API understand that it is
only the RDMA
   device handling of incoming packets and WQEs that is being suspended. The
   peers are not suspended by this API, or even told that this end is
suspending.
   Unless the suspend is kept *extremely* short there will be adverse impacts.
   And "short" here is measured in network terms, not human terms. The blink
   of any eye is *way* too long. Any external dependencies between "suspend"
   and "resume" will probably mean that things will not work, especially if the
   external entities involve a disk drive.

So suspend/resume to re-arrange pages is one thing. Suspend/resume to cover
swapping out pages so they can be reallocated is an exercise in futility. By the
time you resume the connections will be broken or at the minimum damaged.
