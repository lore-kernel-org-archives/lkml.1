Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbYGKWIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbYGKWIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 18:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbYGKWIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 18:08:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:2479 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbYGKWIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 18:08:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=QxPC8pw5263cbIVr3xcjQaI5bj8EU1wblOdS5sfX2zEDmR0fEO59njNl52Ie47cFaE
         TE5HzM0ogT6K6lG5IbCaUqj6Y3DzBkTvXcnB1howbdnfz1KvAaYMel1gGBxdFEHhsz02
         isBjd6/bagPP7XKM1c4JA2g60aof8giX5/Sqg=
Message-ID: <ea8d860a0807111508m74d92fbep84306c80753bf591@mail.gmail.com>
Date: Sat, 12 Jul 2008 00:08:34 +0200
From: "Marcin Obara" <marcin_obara@users.sourceforge.net>
To: Valdis.Kletnieks@vt.edu
Subject: Re: patch tpm-correct-tpm-timeouts-to-jiffies-conversion.patch breaks stuff
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Marcel Selhorst" <tpm@selhorst.net>,
       "Kylene Jo Hall" <kjhall@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <18107.1215803534@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18107.1215803534@turing-police.cc.vt.edu>
X-Google-Sender-Auth: bb219b4efd47a211
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/11  <Valdis.Kletnieks@vt.edu>:
> With tpm-correct-tpm-timeouts-to-jiffies-conversion.patch reverted, I
> get -ETIME errors from libtpm2.0/utils/tpm_demo:
>
> With the patch in place, the first read dies horribly, as reported by
> strace -T -r utils/tpm_demo:
>
> 0.000969 open("/dev/tpm0", O_RDWR) = 3 <0.000080>
> 0.000237 write(3, "\0\301\0\0\0\22\0\0\0e\0\0\0\6\0\0\0\0", 18) = 18 <0.012652>
> 0.012814 read(3, 0x7fffd26cd430, 4096) = -1 ETIME (Timer expired) <0.000068>
> 0.000168 close(3)                  = 0 <0.000041>
> 0.000132 exit_group(-1)            = ?
>
> Note that the write() call took 0.012 seconds, but the read() was hit with
> a -ETIME after only 0.000068 seconds, so it's obviously too short.
Not exactly.
read() call only returns result of already done TPM transmission.
All TPM transmission is done in write() call.
Transmission contains 3 timeoutable operations connected with timeout values:
- timeout 2 (_b) = 2000000 =  2 sec
      in    tpm_tis.c:tpm_tis_send():
           if (wait_for_stat
                   (chip, TPM_STS_COMMAND_READY, chip->vendor.timeout_b,
                    &chip->vendor.int_queue) < 0) {
                       rc = -ETIME;
- for ordinal = 0xe0 - duration TPM_SHORT = 1000 = 0,001 sec
      in    tpm_tis.c:tpm_tis_send():
           if (wait_for_stat
                   (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
                    tpm_calc_ordinal_duration(chip, ordinal),
                    &chip->vendor.read_queue) < 0) {
                       rc = -ETIME;

- timeout 3 (_c) = 750000 = 0,75 sec
      in tmp_tis.c:recv_data():
             wait_for_stat(chip,
                            TPM_STS_DATA_AVAIL | TPM_STS_VALID,
                            chip->vendor.timeout_c,
                            &chip->vendor.read_queue)

So for this example, we have timeouts:
- 2 sec   (timeout_b)
- 0,001 sec    (TPM_SHORT)
- 0,75 sec  (timeout_c)
Transaction time was
 0,013 sec  ( > 0.001)
write() call response would be at least 0,75 sec if failed on
timeout_b or timeout_c.
It looks like duration TPM_SHORT = 1000 returned by your Broadcom chip
is too short (=wrong).

> Dumping the raw values in the 'data + TPM_GET_CAP_mumble' I see:
>
> [ 2170.060661] timeout 1 = 750000
> [ 2170.060866] timeout 2 = 2000000
> [ 2170.060994] timeout 3 = 750000
> [ 2170.061119] timeout 4 = 750000
> [ 2170.072437] raw durations are 1000 2000000 120000000
>
> (all values are before application of foo_to_jiffies)
>
> So is the spec wrong, or is my chipset on drugs, or?

So your chipset is on drugs.

It's strange range of returned timeouts/durations:
0,75 / 2 / 0,75 / 0,75  (sec)
0,001  / 2 / 120 (sec)

With reversed patch timeouts would be:
12,5 min / 33 min / 12,5 min / 12,5 min
1 sec / ~33 min / ~33 hours!!!!
I can not event imagine TPM driver hanging for over 1 day on one write() call .

In my opinion Broadcom 0102 TPM chip is broken.

Regards
Marcin
