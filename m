Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbXIGV1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbXIGV1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 17:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbXIGV1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 17:27:41 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:29752 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758480AbXIGV1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 17:27:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EKYz460rs2LEFRQZ3tjsZrgj6kzDd0a4Da2couMvBfuOzyS2ypCWCUBMd/oUJ10TC/B91VMXpQUi/bDTKxyB4kW/zN6dQRujehrl72xwMbnCOkwuoZkwKbbtEJIweHyBIgoN36wtwhHWhYT5eaXqyR8/WITNT357l3ck9j6XB+4=  ;
X-YMail-OSG: LmFshL4VM1lXbQk9V3uSkTdZL7_DJyu7vX7l3uU3FMxt4SmVL.1w21FP_d1ww_jJZHnaXEYlKA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: patch: improve generic_file_buffered_write() (2nd try 1/2)
Date: Sat, 8 Sep 2007 17:25:06 +1000
User-Agent: KMail/1.9.5
Cc: Bernd Schubert <bs@q-leap.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       brian@clusterfs.com
References: <200709051546.06224.bs@q-leap.de> <200709081628.27310.nickpiggin@yahoo.com.au> <87d4wuch8y.fsf@informatik.uni-tuebingen.de>
In-Reply-To: <87d4wuch8y.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709081725.06343.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 September 2007 07:12, Goswin von Brederlow wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> > On Saturday 08 September 2007 06:01, Goswin von Brederlow wrote:

> >>   b) a segment boundary
> >
> > This is done, as I said, because of the deadlock issue. While the issue
> > is more completely fixed in -mm, a special case for kernel memory (eg.
> > nfsd) is in the latest mainline kernels.
>
> Can you tell me where to get the fix from -mm? If it is completly
> fixed there then that could make our patch obsolete.

In the latest -mm series file, they start at
mm-revert-kernel_ds-buffered-write-optimisation.patch
...
and go to
ocfs2-convert-to-new-aops.patch


> >> What actually locks the page? Is it __grab_cache_page or
> >> a_ops->prepare_write?
> >
> > prepare_write must be given a locked page.
>
> Then that means __grab_cache_page does return a locked page because
> there is nothing between the two calls that would.

That's right.


> > No it would be included earlier. The "segment_eq" check should be
> > allowing kernel writes (nfsd) to write multiple segments. If you have a
> > patch which changes this significantly, then it would indicate the
> > existing logic has a problem (or you've got a userspace application doing
> > the writev, which should be fixed by the write_begin patches in -mm).
>
> I've got userspace application doing the writev. To be exact 14% of
> the commits were saved by combining multiple segments into a single
> prepare/write pair. Since the kernel segments don't fragment anymore
> in 2.6.23-rc5 those savings must come from user space stuff.
>
> From the stats posted earlier you can see that there is a substantial
> amount of calls with 6 segments all (alot) smaller than a page. Lots
> of calls our patch or the write_begin/end will save.

OK. The write_begin/write_end patchset is intrusive, no question. I'm not sure
what you're intending to do with it. They have been tested in -mm for quite a
while now, but just going with a simple patch that tries to copy more segments
might be OK for you if you're backporting. The deadlock is pretty uncommon.
