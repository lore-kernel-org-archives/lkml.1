Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbYBGSyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbYBGSyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 13:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbYBGSyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 13:54:18 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:30035 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbYBGSyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 13:54:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=ujsGYO+kyqlm7A5HdLZKq5KGSw1rVEtSqXq8YWECdxJlZx5pm2o3USYeLscYtITSnjd+/8/OeaDLgJfDoAYpT4JkhBWEzAYQJbL0RbCs7yypPpl3+N4HgpaaGosOOPR9a1JCOzdtZ+GY9D7aGl7U9fQfnNxxFCzxELzC8fBg8Tg=
Message-ID: <d23110170802071054s6fef54c9q182a9ed2e180052@mail.gmail.com>
Date: Thu, 7 Feb 2008 15:54:12 -0300
From: "Ulisses Furquim" <ulissesf@gmail.com>
To: "Clem Taylor" <clem.taylor@gmail.com>
Subject: Re: inotify_add_watch() returning ENOSPC in 2.6.24 [watch descriptor leak?]
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Amy Griffis" <amy.griffis@hp.com>
In-Reply-To: <ecb4efd10802061140g929e699y8d79f1317c30478d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_24987_5072641.1202410452610"
References: <ecb4efd10802051749n6a626e84k3ac8210aa2b5a446@mail.gmail.com>
	 <20080206015103.9a0f4069.akpm@linux-foundation.org>
	 <ecb4efd10802061140g929e699y8d79f1317c30478d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_24987_5072641.1202410452610
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

On Feb 6, 2008 4:40 PM, Clem Taylor <clem.taylor@gmail.com> wrote:
> I also tested on a 2.6.20 x86 desktop machine. It took ~8k iterations
> to fail, which matched max_user_watches. Once the program fails, it
> will fail right away if it is re-run.

Yeah, I had the same results, and it fails afterwards because it
reaches the maximum number of watches per user.

> Attached is a simple example that shows off the problem. On a system
> with a problem, it will only run for about
> fs.inotify.max_user_watches iterations. If everything is working, it
> should run forever.

Ok, I had a go with it and found the problem. We weren't releasing
one-shot watches because the test for them was wrong. We're using the
event's mask to test for one-shot watches when we should've been using
the watch's mask.

Patch against latest Linus git repo attached.

Regards,

-- Ulisses

------=_Part_24987_5072641.1202410452610
Content-Type: application/octet-stream; name=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcdo0vjl0
Content-Disposition: attachment; filename=patch

RnJvbSA2ZmNmM2JiNjIyN2E0OTQ5YWVlZTI3NDFkYzczZWIzYzU1YTNiZmVmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBVbGlzc2VzIEZ1cnF1aW0gPHVsaXNzZXNmQGdtYWlsLmNvbT4K
RGF0ZTogVGh1LCA3IEZlYiAyMDA4IDE1OjE5OjE5IC0wMzAwClN1YmplY3Q6IFtQQVRDSF0gaW5v
dGlmeTogZml4IGNoZWNrIGZvciBvbmUtc2hvdCB3YXRjaGVzIGJlZm9yZSBkZXN0cm95aW5nIHRo
ZW0KCkFzIHRoZSBJTl9PTkVTSE9UIGJpdCBpcyBuZXZlciBzZXQgd2hlbiBhbiBldmVudCBpcyBz
ZW50IHdlIG11c3QgY2hlY2sgaXQKaW4gdGhlIHdhdGNoJ3MgbWFzayBhbmQgbm90IGluIHRoZSBl
dmVudCdzIG1hc2suCgpTaWduZWQtb2ZmLWJ5OiBVbGlzc2VzIEZ1cnF1aW0gPHVsaXNzZXNmQGdt
YWlsLmNvbT4KLS0tCiBmcy9pbm90aWZ5X3VzZXIuYyB8ICAgIDIgKy0KIDEgZmlsZXMgY2hhbmdl
ZCwgMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2lub3Rp
ZnlfdXNlci5jIGIvZnMvaW5vdGlmeV91c2VyLmMKaW5kZXggYTMzNmM5Ny4uM2FiMDlhNiAxMDA2
NDQKLS0tIGEvZnMvaW5vdGlmeV91c2VyLmMKKysrIGIvZnMvaW5vdGlmeV91c2VyLmMKQEAgLTI4
Myw3ICsyODMsNyBAQCBzdGF0aWMgdm9pZCBpbm90aWZ5X2Rldl9xdWV1ZV9ldmVudChzdHJ1Y3Qg
aW5vdGlmeV93YXRjaCAqdywgdTMyIHdkLCB1MzIgbWFzaywKIAkvKiB3ZSBjYW4gc2FmZWx5IHB1
dCB0aGUgd2F0Y2ggYXMgd2UgZG9uJ3QgcmVmZXJlbmNlIGl0IHdoaWxlCiAJICogZ2VuZXJhdGlu
ZyB0aGUgZXZlbnQKIAkgKi8KLQlpZiAobWFzayAmIElOX0lHTk9SRUQgfHwgbWFzayAmIElOX09O
RVNIT1QpCisJaWYgKG1hc2sgJiBJTl9JR05PUkVEIHx8IHctPm1hc2sgJiBJTl9PTkVTSE9UKQog
CQlwdXRfaW5vdGlmeV93YXRjaCh3KTsgLyogZmluYWwgcHV0ICovCiAKIAkvKiBjb2FsZXNjaW5n
OiBkcm9wIHRoaXMgZXZlbnQgaWYgaXQgaXMgYSBkdXBlIG9mIHRoZSBwcmV2aW91cyAqLwotLSAK
MS41LjQKCg==
------=_Part_24987_5072641.1202410452610--
