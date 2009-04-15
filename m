Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbZDOITP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbZDOITP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZDOIS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:18:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35304 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbZDOIS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:18:56 -0400
Date: Wed, 15 Apr 2009 10:17:21 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, jgarzik@pobox.com, davem@davemloft.net,
       shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: [PATCH 0/3] bonding: allow bond in mode balance-alb to work
	properly in bridge -try6
Message-ID: <20090415081720.GA21342@psychotron.englab.brq.redhat.com>
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313183303.GF3436@psychotron.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resend, rcu list locking, cometics)

Hi all.

The problem is described in following bugzilla:
https://bugzilla.redhat.com/show_bug.cgi?id=487763

Basically here's what's going on. In every mode, bonding interface uses the same
mac address for all enslaved devices (except fail_over_mac). Only balance-alb
will simultaneously use multiple MAC addresses across different slaves. When you
put this kind of bond device into a bridge it will only add one of mac adresses
into a hash list of mac addresses, say X. This mac address is marked as local.
But this bonding interface also has mac address Y. Now then packet arrives with
destination address Y, this address is not marked as local and the packed looks
like it needs to be forwarded. This packet is then lost which is wrong.

Notice that interfaces can be added and removed from bond while it is in bridge.

This patchset solves this issue in the best way it can be possibly solved. By
adding all mac addresses of all slave devices to the bridge hash list. To carry
these addresses the new list has to be introduced in struct net_device.

Jirka

