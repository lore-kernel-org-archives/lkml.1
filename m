Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbZBJF4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbZBJF4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 00:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZBJF4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 00:56:44 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:30412 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750920AbZBJF4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 00:56:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QZELdwSGQz5AwVUv66zJlFx19YrOjxJDpMAANb2uivfu5erbvemC1/j9v+WNHIh8iDJ5/xlm8uHdRQrzzbgkIkdF+XnvJA/5GsAZ9pCoam2M6+Sd2Qs8hmPtYsBOXPGJIl45fkon/taRKA3u53jwKrb4l2IGLdjAmaBGWvUqifA=  ;
X-YMail-OSG: _EnS36sVM1kp.GPQufDtltHA2oX6I9OryZ.hDgy6ZJUGkOT6lZ_JEzPicH5eTeFqdtB48tdDnoozB3FgT.P.xgn3Y3J7efakcFpBiDPWxlVOkjToSvvNypHV7dTeKfDxpjwtTomSYEVs_1EOB166S8WOoojhVDSaOGW_8QfoclUKNvjPxl8hANvkDBwthA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm fix page writeback accounting to fix oom condition under heavy I/O
Date: Tue, 10 Feb 2009 16:56:13 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       thomas.pi@arcor.dea, Yuriy Lalym <ylalym@gmail.com>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <20090120122855.GF30821@kernel.dk> <20090210033652.GA28435@Krystal> <alpine.LFD.2.00.0902092120450.3048@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902092120450.3048@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902101656.13792.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 February 2009 16:23:56 Linus Torvalds wrote:
> On Mon, 9 Feb 2009, Mathieu Desnoyers wrote:
> > So this patch fixes this behavior by only decrementing the page
> > accounting _after_ the block I/O writepage has been done.
>
> This makes no sense, really.
>
> Or rather, I don't mind the notion of updating the counters only after IO
> per se, and _that_ part of it probably makes sense. But why is it that you
> only then fix up two of the call-sites. There's a lot more call-sites than
> that for this function.

Well if you do that, then I'd think you also have to change some
calculations that today use dirty+writeback.

In some ways it does make sense, but OTOH it is natural in the
pagecache since it was introduced to treat writeback as basically
equivalent to dirty. So writeback && !dirty pages shouldn't cause
things to blow up, or if it does then hopefully it is a simple
bug somewhere.

