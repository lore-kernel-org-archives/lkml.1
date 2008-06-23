Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYFWOqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYFWOqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbYFWOqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:46:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:40648 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754260AbYFWOqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:46:42 -0400
X-Authenticated: #2724694
X-Provags-ID: V01U2FsdGVkX19fE7Anb4Nfn8NK/ANEn/j2HVVqjJqSgdHUiRTbXN
	Q75P8WPCG5CJka
Message-ID: <485FB75E.4030606@gmx.net>
Date: Mon, 23 Jun 2008 16:46:54 +0200
From: Peter Beutner <p.beutner@gmx.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: free_beer_for_all@yahoo.com, linux-kernel@vger.kernel.org,
       Alex Woods <linux-dvb@giblets.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Broken ttusb-dec DVB support since, well, year(s)
References: <399205.76644.qm@web46108.mail.sp1.yahoo.com> <20080623003747.f167b1af.akpm@linux-foundation.org>
In-Reply-To: <20080623003747.f167b1af.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------070203080006010009080403"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070203080006010009080403
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton schrieb:
> On Sun, 22 Jun 2008 23:55:29 -0700 (PDT) barry bouwsma <free_beer_for_all@yahoo.com> wrote:
> 
>> Moin moin!
>>
>> Sorry I'm posting this here rather than to the more specific
>> linux-dvb@ mailing list where I'd rather this appear, but my
>> attempts to surbscibe!@! to that list have been rejected, first
>> as an invalid e-mail, then an insecure e-mail, and I've been
>> unable to progress further from this throwaway account.
> 
> These closed lists are a pain.
> 
> Lots of subprojects have moved their lists to vger.kernel.org in recent
> months.  It gets close to zero spam.  Hint.
> 
>> Feel free to redirect/repost this message there if you're a
>> qualified developer and feel it's more appropriate.
>>
>>
>> There is a change that was introduced to the file
>> drivers/media/dvb/ttusb-dec/ttusbdecfe.c
>> sometime in the not-too-recent past and which resulted in breaking
>> the support which early 2.6.1x kernels had for my Hauppauge
>> DEC-3000s DVB-S device.

So only dvb-s support is broken. The DEC-2000t (hopefully) still works.
If there is still somebody around using that thing ;)
Honestly, I wasn't aware that the DEC-3000s has ever really worked.

>>
>> The particular code (below) checks the value in a register to
>> decide the tuning status -- hitherto one had to assume the device
>> was properly tuned and receiving signal and everything.
>>
>>
>>      60         switch(result[3]) {
>>      61                 case 1:  /* not tuned yet */
>>      62                 case 2:  /* no signal/no lock*/
>>      63                         break;
>>      64                 case 3:  /* signal found and locked*/
>>      65                         *status = FE_HAS_SIGNAL | FE_HAS_VITERBI |
>>      66                         FE_HAS_SYNC | FE_HAS_CARRIER | FE_HAS_LOCK;
>>      67                         break;
>>      68                 case 4:
>>      69                         *status = FE_TIMEDOUT;
>>      70                         break;
>>      71                 default:
>>      72                         pr_info("%s: returned unknown value: %d\n",
>>      73                                 __func__, result[3]);
>>      74                         return -EIO;
>>      75         }
>>
>>
>> Unfortunately, while this might work for the other flavours of
>> card (DVB-T?) supported by this code, in the case of my particular
>> device for DVB-S, the unknown value returned is 0 and does not
>> change regardless of tuning status.
>>
>> I haven't checked whether a different register on my particular
>> device contains a usable value for the above code.
>>
>> In any case, with my particular device, in order to use more
>> recent kernels, I've had to add a ``case 0:'' line to the
>> ``case 3:'' seen above in order to get the previous behaviour
>> where no check was made.
>>

Indeed I added the above code only for the dec2000-t model. Since I have no
idea how that stuff works on the dec3000, probably the best thing to do is to
revert to the old behaviour for dec3000s models, i.e. just pretend we always have
a signal. Something like the attached patch. Does that help?


>>
>> As I don't know the particular model for which the quoted code
>> was added, I don't know if my device is unique, or whether the
>> number of DVB-S users of this code is miniscule, as nobody else
>> has complained that I've seen.
>>

well, i remember at least one report on the linux-dvb ml a long time ago
and iirc I have posted the same patch there, but it didn't help.
We never figured out how to make that particular dec3000s work.
And without hw documentation this is more like a puzzle game.
Which is rather demotivating.

--------------070203080006010009080403
Content-Type: text/x-patch;
 name="dont-try-to-readout-signal-status-for-dec3000s.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="dont-try-to-readout-signal-status-for-dec3000s.patch"

As reported by BOUWSMA Barry the readout of the signal status doesn't work
on dec3000-s models. Since we don't know how to do it better, revert back
to the old behaviour and always report a signal lock.

Signed-off-by: Peter Beutner <p.beutner@gmx.net>
--- linux/drivers/media/dvb/ttusb-dec/ttusbdecfe.c.orig	2008-06-23 09:50:00.000000000 +0200
+++ linux/drivers/media/dvb/ttusb-dec/ttusbdecfe.c	2008-06-23 09:53:27.000000000 +0200
@@ -38,7 +38,15 @@ struct ttusbdecfe_state {
 };
 
 
-static int ttusbdecfe_read_status(struct dvb_frontend* fe, fe_status_t* status)
+static int ttusbdecfe_dvbs_read_status(struct dvb_frontend* fe, fe_status_t* status)
+{
+	*status = FE_HAS_SIGNAL | FE_HAS_VITERBI |
+		FE_HAS_SYNC | FE_HAS_CARRIER | FE_HAS_LOCK;
+	return 0;
+}
+
+
+static int ttusbdecfe_dvbt_read_status(struct dvb_frontend* fe, fe_status_t* status)
 {
 	struct ttusbdecfe_state* state = fe->demodulator_priv;
 	u8 b[] = { 0x00, 0x00, 0x00, 0x00,
@@ -251,7 +259,7 @@ static struct dvb_frontend_ops ttusbdecf
 
 	.get_tune_settings = ttusbdecfe_dvbt_get_tune_settings,
 
-	.read_status = ttusbdecfe_read_status,
+	.read_status = ttusbdecfe_dvbt_read_status,
 };
 
 static struct dvb_frontend_ops ttusbdecfe_dvbs_ops = {
@@ -273,7 +281,7 @@ static struct dvb_frontend_ops ttusbdecf
 
 	.set_frontend = ttusbdecfe_dvbs_set_frontend,
 
-	.read_status = ttusbdecfe_read_status,
+	.read_status = ttusbdecfe_dvbs_read_status,
 
 	.diseqc_send_master_cmd = ttusbdecfe_dvbs_diseqc_send_master_cmd,
 	.set_voltage = ttusbdecfe_dvbs_set_voltage,


--------------070203080006010009080403--
