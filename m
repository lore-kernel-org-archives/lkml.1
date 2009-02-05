Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbZBEDZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbZBEDZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 22:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZBEDZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 22:25:47 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:35812 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753469AbZBEDZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 22:25:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=16GdKYhLlSHDZX1M4mz552KgxbTYcJRUhD6mNBdG7Ma2LgJ12kl87SIiF+9JBS4hkifd5NUojSnnwsb9fvsECNInDY6B6pTTm4/sAu9eCfRZnrx1r1pSa4neRyxZigVF0mM7f8bxADNEOymNOoG0vczV0eqnohcTI6uQmuCDyrY=  ;
X-YMail-OSG: SvEUAUgVM1me5Jx1zifN7JCYSQ6aHwsLkJu.r4cDT_YkHbjM.LV3yqBf8w8Ew0YCJmlPSQioXSj_upFK7C5A2_04wDiTSKQBCSgRTx3WKcWvo2kR3JHsaEIHhh4oYcXEZvyG2yuar6Sc7U.Vl5J1zgyU6Wwf.MmiFdeBMyRHM5O_TXk7KQTeRgxIBZgBZHYVbYEp0o.BIj_YPq6rTOOj4.Dku1KCyDvsfoE9SI0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Federico Cuello <fedux@lugmen.org.ar>
Subject: Re: sync-Regression in 2.6.28.2?
Date: Thu, 5 Feb 2009 14:25:19 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
References: <20090127093533.GB7037@charite.de> <200902041717.27320.nickpiggin@yahoo.com.au> <4989D0D4.80300@lugmen.org.ar>
In-Reply-To: <4989D0D4.80300@lugmen.org.ar>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051425.19552.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009 04:31:00 Federico Cuello wrote:
> Nick Piggin wrote:
> > [...]
> > Thanks, could you reply-to-all when replying to retain ccs please?
> >
> > Common theme is ext4, which uses no_nrwrite_index_update, and I
> > introduced a bug in there which could possibly cause ext4 to go into a
> > loop...
> >
> > Would it be possible if you can test the following patch?
>
> I'll test it as soon as I get home.

Thanks.


> Meanwhile, I think the new patch may be slightly wrong. If I understand
> correctly PageWriteback(page) is called before nr_to_write is tested for
> being > 0 and then decremented if true, but "done" is  not set to 1
> until the next iteration. So another call to PageWriteback(page) while
> take place and then "done" will be set to true (if wbc->sync_mode ==
> WB_SYNC_NONE).
>
> If nr_to_write == 1 at the beginning of the loop then two pages will be
> written.
>
> I think the test condition should something like:
>
> if (--nr_to_write <= 0 && wbc->sync_mode == WB_SYNC_NONE) {
>     done = 1;
>     break;
> }

I think you're quite right. Good catch. We probably want to prevent
nr_to_write from going -ve, though.

I think something like this

  if (nr_to_write > 0)
    nr_to_write--;
  if (!nr_to_write && wbc->sync_mode == WB_SYNC_NONE) {
    ...

Would you care to send a patch?

Thanks,
Nick

