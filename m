Return-Path: <linux-kernel-owner+w=401wt.eu-S1763885AbYDOMOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763885AbYDOMOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYDOMOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:14:05 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:41077 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751829AbYDOMOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:14:05 -0400
X-Greylist: delayed 853 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2008 08:14:04 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=O4nJIan6O+73OJ2JizaCajzcTVVUVoSf70mYmRS2QbuFO040UKc4Za6RtJI5nDV2u3IGSiraER5aNJ3O9rU4ySZCzRYSnokz/Rnbc5YrxyjiCRiMUg+IMM1KVFERv2kItL8iYtmcwnMIYqocBId7PCQOo/JVuFjHJwDATAISq18=;
Date: Tue, 15 Apr 2008 15:59:24 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vitaliy Gusev <vgusev@openvz.org>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH][NET] Fix never pruned tcp out-of-order queue
Message-ID: <20080415115924.GA1550@ms2.inr.ac.ru>
References: <87mynvtuoj.fsf@basil.nowhere.org> <87iqyjttz3.fsf@basil.nowhere.org> <20080415.011810.178212948.davem@davemloft.net> <200804151226.47729.vgusev@openvz.org> <480467AA.2050808@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480467AA.2050808@firstfloor.org>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> I still think the guards are pretty much the same as before, sorry:)

Guards inside tcp_prune_queue() are the same exactly.

But the patch adds the second point where out-of-order queue is discarded.
It is when the socket is under rcvbuf, but nevertheless skb cannot
be queued due to system-wide limit. In that case out-of-order queue
is dropped and the limits are rechecked.


> But why not repeat the whole prune for all cases in this case then?

Collapsing and tuning rcv_ssthresh was done once, they are not guarded
by rcvbuf check. So, repeating those steps would be useless.

The only thing is:

> e.g. you should probably at least repeat the third step (setting
> pred_flags to 0) too.

Formally, this is correct. But this is not necessary, pred_flags reset
is redundant even in the first place. The fast path is not so fast,
memory limit is checked explicitly there.


The patch is not perfect. F.e. tcp_prune_ofo_queue() could see empty
out-of-order queue, in this case the second sk_stream_rmem_schedule()
is useless and could be skipped. But it is the second order effect.

I think this will work.






