Return-Path: <linux-kernel-owner+w=401wt.eu-S1759139AbYIAL5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139AbYIAL5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYIAL5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:57:31 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:44166 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYIAL5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=RxLW4mVPZjnJyLDygXaUlHUtXw4nH9AzIiJhhBn2N7YoXuQl9Kjg5nU+3EpPnkj3Q3
         XLeHPA31u+4QqM7QS3xjGT37Bfrqps8tRDw3s9a1A5wJ8qp0buU5f8tOMuiXrCRgnG6M
         decSf6/+slJ4dJHr1WcBrOl9bgvsuJZXdT22g=
Message-ID: <5ff4a1e50809010457l7051b7e8vc7f86d68ae42e529@mail.gmail.com>
Date: Mon, 1 Sep 2008 12:57:29 +0100
From: "Matt Fleming" <mattjfleming@googlemail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: ktime_set() does not check for nanoseconds > one second
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0809011317460.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_20170_18664562.1220270249532"
References: <5ff4a1e50809010338o77fffec4w625ed48b3987d51@mail.gmail.com>
	 <alpine.LFD.1.10.0809011317460.3243@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_20170_18664562.1220270249532
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/9/1 Thomas Gleixner <tglx@linutronix.de>:
> On Mon, 1 Sep 2008, Matt Fleming wrote:
>>
>> is it intentional that ktime_set() does not check whether the
>> nanoseconds argument is greater than the number of nanoseconds in a
>> second? I've run into a problem where a value of 1600000000
>> nanoseconds was passed as an argument to ktime_set() and the return
>> value was then used in a ktime_add() call, which returned an incorrect
>> result. Should the caller of ktime_set() make this check or is it
>> possible to move this logic in to the function itself?
>
> Yeah, a check for this in ktime_set() might make sense. Currently it's
> up to the programmer to provide sane values. :)
>
> Thanks,
>
>        tglx
>

How about the attached patch?

Matt

diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index ce59832..7c0ad35 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -150,7 +150,19 @@ static inline ktime_t timeval_to_ktime(struct timeval tv)
 /* Set a ktime_t variable to a value in sec/nsec representation: */
 static inline ktime_t ktime_set(const long secs, const unsigned long nsecs)
 {
-       return (ktime_t) { .tv = { .sec = secs, .nsec = nsecs } };
+       ktime_t res = { .tv = { .sec = secs, .nsec = nsecs }};;
+
+       /*
+        * performance trick: the (u32) -NSEC gives 0x00000000Fxxxxxxx
+        * so we subtract NSEC_PER_SEC and add 1 to the upper 32 bit.
+        *
+        * it's equivalent to:
+        *   tv.nsec -= NSEC_PER_SEC
+        *   tv.sec ++;
+        */
+       if (nsecs >= NSEC_PER_SEC)
+               res.tv64 += (u32)-NSEC_PER_SEC;
+       return res;
 }

 /**

------=_Part_20170_18664562.1220270249532
Content-Type: text/x-diff;
 name=ktime-check-for-seconds-in-nanoseconds.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkl1e1uo0
Content-Disposition: attachment;
 filename=ktime-check-for-seconds-in-nanoseconds.patch

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgva3RpbWUuaCBiL2luY2x1ZGUvbGludXgva3RpbWUu
aAppbmRleCBjZTU5ODMyLi43YzBhZDM1IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2t0aW1l
LmgKKysrIGIvaW5jbHVkZS9saW51eC9rdGltZS5oCkBAIC0xNTAsNyArMTUwLDE5IEBAIHN0YXRp
YyBpbmxpbmUga3RpbWVfdCB0aW1ldmFsX3RvX2t0aW1lKHN0cnVjdCB0aW1ldmFsIHR2KQogLyog
U2V0IGEga3RpbWVfdCB2YXJpYWJsZSB0byBhIHZhbHVlIGluIHNlYy9uc2VjIHJlcHJlc2VudGF0
aW9uOiAqLwogc3RhdGljIGlubGluZSBrdGltZV90IGt0aW1lX3NldChjb25zdCBsb25nIHNlY3Ms
IGNvbnN0IHVuc2lnbmVkIGxvbmcgbnNlY3MpCiB7Ci0JcmV0dXJuIChrdGltZV90KSB7IC50diA9
IHsgLnNlYyA9IHNlY3MsIC5uc2VjID0gbnNlY3MgfSB9OworCWt0aW1lX3QgcmVzID0geyAudHYg
PSB7IC5zZWMgPSBzZWNzLCAubnNlYyA9IG5zZWNzIH19OzsKKwkKKwkvKgorCSAqIHBlcmZvcm1h
bmNlIHRyaWNrOiB0aGUgKHUzMikgLU5TRUMgZ2l2ZXMgMHgwMDAwMDAwMEZ4eHh4eHh4CisJICog
c28gd2Ugc3VidHJhY3QgTlNFQ19QRVJfU0VDIGFuZCBhZGQgMSB0byB0aGUgdXBwZXIgMzIgYml0
LgorCSAqCisJICogaXQncyBlcXVpdmFsZW50IHRvOgorCSAqICAgdHYubnNlYyAtPSBOU0VDX1BF
Ul9TRUMKKwkgKiAgIHR2LnNlYyArKzsKKwkgKi8KKwlpZiAobnNlY3MgPj0gTlNFQ19QRVJfU0VD
KQorCQlyZXMudHY2NCArPSAodTMyKS1OU0VDX1BFUl9TRUM7CisJcmV0dXJuIHJlczsKIH0KIAog
LyoqCg==
------=_Part_20170_18664562.1220270249532--
