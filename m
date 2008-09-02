Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbYIBTE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbYIBTE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 15:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYIBTES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 15:04:18 -0400
Received: from proofpoint3.lanl.gov ([204.121.3.28]:37567 "EHLO
	proofpoint3.lanl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYIBTER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 15:04:17 -0400
X-CTN-5-Virus-Scanner: amavisd-new at mailrelay2.lanl.gov
Subject: Re: [PATCH] 9p bug fix: return non-zero error value in p9_put_data
From: Abhishek Kulkarni <kulkarni@lanl.gov>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1219948516.2678.16.camel@blender>
References: <1219771831.16125.12.camel@blender>
	 <a4e6962a0808281110s6ee6c86ak3ff6e28c51981656@mail.gmail.com>
	 <1219948516.2678.16.camel@blender>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 13:04:58 -0600
Message-Id: <1220382298.14226.4.camel@blender>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-CTN-5-MailScanner-Information: Please see http://network.lanl.gov/email/virus-scan.php
X-CTN-5-MailScanner: Found to be clean
X-CTN-5-MailScanner-From: kulkarni@lanl.gov
X-Proofpoint-Virus-Version: vendor=fsecure engine=4.65.7161:2.4.4,1.2.40,4.0.164 definitions=2008-09-02_10:2008-09-02,2008-09-02,2008-09-02 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmitting my previous 9p bug fix patch that removes the bogus return
value in p9_put_data which made every p9_client_write fail. 

Signed-off-by: Abhishek Kulkarni <kulkarni@lanl.gov>
---
 net/9p/conv.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/net/9p/conv.c b/net/9p/conv.c
index 4454720..08ec35a 100644
--- a/net/9p/conv.c
+++ b/net/9p/conv.c
@@ -446,13 +446,12 @@ p9_put_str(struct cbuf *bufp, char *data, struct
p9_str *str)
        }
 }

-static int
+static void
 p9_put_data(struct cbuf *bufp, const char *data, int count,
                   unsigned char **pdata)
 {
        *pdata = buf_alloc(bufp, count);
        memmove(*pdata, data, count);
-       return count;
 }

 static int
@@ -851,7 +850,7 @@ EXPORT_SYMBOL(p9_create_tread);
 struct p9_fcall *p9_create_twrite(u32 fid, u64 offset, u32 count,
                                      const char *data)
 {
-       int size, err;
+       int size;
        struct p9_fcall *fc;
        struct cbuf buffer;
        struct cbuf *bufp = &buffer;
@@ -865,12 +864,7 @@ struct p9_fcall *p9_create_twrite(u32 fid, u64
offset, u32 count,
        p9_put_int32(bufp, fid, &fc->params.twrite.fid);
        p9_put_int64(bufp, offset, &fc->params.twrite.offset);
        p9_put_int32(bufp, count, &fc->params.twrite.count);
-       err = p9_put_data(bufp, data, count, &fc->params.twrite.data);
-       if (err) {
-               kfree(fc);
-               fc = ERR_PTR(err);
-               goto error;
-       }
+       p9_put_data(bufp, data, count, &fc->params.twrite.data);

        if (buf_check_overflow(bufp)) {
                kfree(fc);
--
1.5.4.3



On Thu, 2008-08-28 at 12:35 -0600, Abhishek Kulkarni wrote:
> On Thu, 2008-08-28 at 11:10 -0700, Eric Van Hensbergen wrote:
> > On Tue, Aug 26, 2008 at 10:30 AM, Abhishek Kulkarni <kulkarni@lanl.gov> wrote:
> > > p9_put_data is called by p9_create_twrite which expects it to return a
> > > non-zero value on error. This was the reason why every p9_client_write
> > > was failing. This patch also adds a check for buffer overflow in
> > > p9_put_data.
> > >
> > 
> > I'm a bit confused about when this is even getting called -- O thought
> > all writes were following the p9_client_uwrite path?
> 
> Yes, this bug didn't come up to the surface since p9_create_twrite is
> not even being called anywhere in v9fs. I tripped over it when using 9p
> for a different module that I am working on. 
> 
> > 
> > Also, we do the bufoverflow check in p9_create_write -- so with your
> > patch aren't we doing this twice?
> > 
> Yes, but then that makes the "check for error in return value" in
> p9_create_twrite useless since memmove is not going to return an error
> in any case.
> 
> Going with the existing convention however, I think the bufoverflow
> check is unnecessary in p9_put_data and so is the check for error on
> return.
> 
> I'll resubmit a patch.
> 
>  -- Abhishek
> 
> 
> >            -eric
> > 
> > 
> > > Signed-off-by: Abhishek Kulkarni <kulkarni@lanl.gov>
> > > ---
> > >  net/9p/conv.c |    5 ++++-
> > >  1 files changed, 4 insertions(+), 1 deletions(-)
> > > diff --git a/net/9p/conv.c b/net/9p/conv.c
> > > index 4454720..7f6db15 100644
> > > --- a/net/9p/conv.c
> > > +++ b/net/9p/conv.c
> > > @@ -451,8 +451,11 @@ p9_put_data(struct cbuf *bufp, const char *data,
> > > int count,
> > >                   unsigned char **pdata)
> > >  {
> > >        *pdata = buf_alloc(bufp, count);
> > > +       if (buf_check_overflow(bufp))
> > > +               return -EIO;
> > > +
> > >        memmove(*pdata, data, count);
> > > -       return count;
> > > +       return 0;
> > >  }
> > >
> > >  static int
> > >
> > >
> > > Thanks,
> > >  -- Abhishek
> > >
> > >

