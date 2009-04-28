Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZD1UGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZD1UGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZD1UGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:06:23 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:33135 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbZD1UGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:06:19 -0400
Message-ID: <49F76174.6060009@cosmosbay.com>
Date: Tue, 28 Apr 2009 22:05:08 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       jesse.brandeburg@intel.com, netdev@vger.kernel.org, haoki@redhat.com,
       mchan@broadcom.com, davidel@xmailserver.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] poll: Avoid extra wakeups in select/poll
References: <alpine.DEB.1.10.0904241554100.29995@qirst.com> <49F3308B.1030507@cosmosbay.com> <20090426.020411.157511269.davem@davemloft.net> <49F43B8F.2050907@cosmosbay.com> <87ab60rh8t.fsf@basil.nowhere.org> <49F71B63.8010503@cosmosbay.com> <alpine.DEB.1.10.0904281501300.13862@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0904281501300.13862@qirst.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 28 Apr 2009 22:05:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> For the udpping test load these patches have barely any effect:
> 
> git2p1 is the first version of the patch
> git2p2 is the second version (this one)

But... udpping does *not* use poll() nor select(), unless I am mistaken ?

If you really want to test this patch with udpping, you might add a poll() call
before recvfrom() :

                while(1) {
+                       struct pollfd pfd = { .fd = sock, .events = POLLIN};
+                       poll(pfd, 1, -1);
                        nbytes = recvfrom(sock, msg, min(inblocksize, sizeof(msg)),
                                                                0, &inad, &inadlen);
                        if (nbytes < 0) {
                                perror("recvfrom");
                                break;
                        }
                        if (sendto(sock, msg, nbytes, 0, &inad, inadlen) < 0) {
                                perror("sendto");
                                break;
                        }
                }

Part about recvfrom() wakeup avoidance is in David net-2.6 tree, and saves 2 us on udpping here.

Is it what you call git2p1 ?



