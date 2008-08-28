Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbYH1Se5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbYH1Se5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYH1Set
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:34:49 -0400
Received: from proofpoint3.lanl.gov ([204.121.3.28]:40450 "EHLO
	proofpoint3.lanl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbYH1Ses (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:34:48 -0400
X-CTN-5-Virus-Scanner: amavisd-new at mailrelay1.lanl.gov
Subject: Re: [PATCH] 9p bug fix: return non-zero error value in p9_put_data
From: Abhishek Kulkarni <kulkarni@lanl.gov>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <a4e6962a0808281110s6ee6c86ak3ff6e28c51981656@mail.gmail.com>
References: <1219771831.16125.12.camel@blender>
	 <a4e6962a0808281110s6ee6c86ak3ff6e28c51981656@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 12:35:16 -0600
Message-Id: <1219948516.2678.16.camel@blender>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-CTN-5-MailScanner-Information: Please see http://network.lanl.gov/email/virus-scan.php
X-CTN-5-MailScanner: Found to be clean
X-CTN-5-MailScanner-From: kulkarni@lanl.gov
X-Proofpoint-Virus-Version: vendor=fsecure engine=4.65.7161:2.4.4,1.2.40,4.0.164 definitions=2008-08-28_11:2008-08-28,2008-08-28,2008-08-28 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-28 at 11:10 -0700, Eric Van Hensbergen wrote:
> On Tue, Aug 26, 2008 at 10:30 AM, Abhishek Kulkarni <kulkarni@lanl.gov> wrote:
> > p9_put_data is called by p9_create_twrite which expects it to return a
> > non-zero value on error. This was the reason why every p9_client_write
> > was failing. This patch also adds a check for buffer overflow in
> > p9_put_data.
> >
> 
> I'm a bit confused about when this is even getting called -- O thought
> all writes were following the p9_client_uwrite path?

Yes, this bug didn't come up to the surface since p9_create_twrite is
not even being called anywhere in v9fs. I tripped over it when using 9p
for a different module that I am working on. 

> 
> Also, we do the bufoverflow check in p9_create_write -- so with your
> patch aren't we doing this twice?
> 
Yes, but then that makes the "check for error in return value" in
p9_create_twrite useless since memmove is not going to return an error
in any case.

Going with the existing convention however, I think the bufoverflow
check is unnecessary in p9_put_data and so is the check for error on
return.

I'll resubmit a patch.

 -- Abhishek


>            -eric
> 
> 
> > Signed-off-by: Abhishek Kulkarni <kulkarni@lanl.gov>
> > ---
> >  net/9p/conv.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > diff --git a/net/9p/conv.c b/net/9p/conv.c
> > index 4454720..7f6db15 100644
> > --- a/net/9p/conv.c
> > +++ b/net/9p/conv.c
> > @@ -451,8 +451,11 @@ p9_put_data(struct cbuf *bufp, const char *data,
> > int count,
> >                   unsigned char **pdata)
> >  {
> >        *pdata = buf_alloc(bufp, count);
> > +       if (buf_check_overflow(bufp))
> > +               return -EIO;
> > +
> >        memmove(*pdata, data, count);
> > -       return count;
> > +       return 0;
> >  }
> >
> >  static int
> >
> >
> > Thanks,
> >  -- Abhishek
> >
> >

