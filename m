Return-Path: <linux-kernel-owner+w=401wt.eu-S1762292AbYBRWig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762292AbYBRWig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761923AbYBRWiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:38:23 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:6015 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760357AbYBRWiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:38:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:bcc:subject:message-id:reply-to:in-reply-to;
        b=orouaE8OSbZPamaboxQQw++3n/tnpELmJZU8gVNIVDWrlNrQ8+S1efXOctm9JkPprgLwfcWNVHcDoSly51YnPo6FhMMJi5nFOcerpkYCGD8wf+SubT9wefXWQKtB+lJq7+62I73KcsF3ol3Vlrk85gVH+tvfe0SC3USQdX2NWK4=
Date: Mon, 18 Feb 2008 14:46:18 -0800
From: Glenn Griffin <ggriffin.kernel@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: ggriffin.kernel@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Support arbitrary initial TCP timestamps
Message-ID: <20080218164723.GA13941@fin>
In-Reply-To: <20080217.233330.157255657.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Adding yet another member to the already bloated tcp_sock structure to
> implement this is too high a cost.

Yes, I was worried that would be deemed too high of a cost, but it was
the most efficient way I could think to accomplish what I wanted.

> I would instead prefer that there be some global random number
> calculated when the first TCP socket is created, and use that as a
> global offset.  You can even recompute it every few hours if you
> like.

That would work fine if my mine purpose was to randomize the tcp
timestamp to mitigate the leak in information regarding uptime, but
despite the brief description, that's only a side effect of what I
intended to do.  What I wanted was a way to be able to choose an initial
tcp timestamp for a particular connection that was not tied directly to
jiffies.

The two patches following this show my intended use case.  I intend to
enhance syncookie support to allow it to support advanced tcp options
(sack and window scaling).  Normally syncookies encode the bare minimum
state of a connection in the ISN they choose, but the 32bit ISN isn't
enough to encode advanced tcp options so you are left with a working but
crippled tcp stack during a synflood attack.  If in addition to choosing
an ISN we are able to choose an initial tcp timestamp, we are then able
to encode an additional 32 bits of information that can contain more of
the advanced tcp options.

This stems from a discussion about implementing IPv6 support for
syncookies, and the main concern being that syncookies disabled too many
valuable tcp features to be relevant on modern systems.  Many people
stood in opposition to that statement, but it did not seem as though a
general consensus was reached.  http://lkml.org/lkml/2008/2/4/396

I'm always open to alternatives.

--Glenn
