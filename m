Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYHMLun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYHMLun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 07:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYHMLuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 07:50:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:1544 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYHMLue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 07:50:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=AEZvIYFVTgqKxk0D+tuOYhyf1okLkFAM/hDoOsLJFkD0Dgn90Sl7VMGPkWgx3ofHdZ
         b/d5VhxEdSc258UmVSWSLjqK3qXGxDpeb8gy6N872nwmaiN9PLKQF2/ZOV6MRvEYLP0B
         TcSMKwf/HwgfPFhIsSyWyAUoHgqgHmdUcPOqw=
Message-ID: <520f0cf10808130450w72757a4dp9b9b0942d6c6a1b1@mail.gmail.com>
Date: Wed, 13 Aug 2008 13:50:32 +0200
From: "John Kacur" <jkacur@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: drop overzealous ERROR: do not initialise statics to 0 or NULL from checkpatch.pl
Cc: "Andy Whitcroft" <apw@shadowen.org>, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
In-Reply-To: <520f0cf10808130339r5dd22e12w3477d6bddd545db1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_55673_4800384.1218628232452"
References: <520f0cf10808130339r5dd22e12w3477d6bddd545db1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_55673_4800384.1218628232452
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Aug 13, 2008 at 12:39 PM, John Kacur <jkacur@gmail.com> wrote:
> Could we drop this somewhat overzealous "ERROR: do not initialise
> statics to 0 or NULL" from checkpatch.pl?
>
> Reasoning:
> 1. This is not part of Documentation/CodingStyle
> 2. K&R 2nd.ed do it (pg 83, static int bufp = 0;) The purpose is to
> remove access to the bufp from external routines, and to avoid name
> conflict)
> 3. It can be a good form of documentation.
> 4. It creates a lot of needless code churn to change this kind of
> thing for no good reason.
> 5. It doesn't even change the object size (thus kernel size) to do so.
> Demo with user space code.
>
> jkacur@linux-ipxk:~/try> cat foo.c
> #include <stdio.h>
> #include <stdlib.h>
>
> static int a[1000];
>
> /* Function Prototype */
> void foo(void);
> int main(void)
> {
>        exit(0);
> }
>
> void foo(void)
> {
>        static int b[1000];
>        static int c;
> }
> jkacur@linux-ipxk:~/try> gcc foo.c
> jkacur@linux-ipxk:~/try> size a.out
>   text    data     bss     dec     hex filename
>   1203     520    8064    9787    263b a.out
> jkacur@linux-ipxk:~/try> ls -l a.out
> -rwxr-xr-x 1 jkacur users 11237 2008-08-13 12:26 a.out
>
> Now initialize all the statics to 0 and there will be no difference in
> the object size
> jkacur@linux-ipxk:~/try> cat foo.c
> #include <stdio.h>
> #include <stdlib.h>
>
> static int a[1000] = {0};
>
> /* Function Prototype */
> void foo(void);
> int main(void)
> {
>        exit(0);
> }
>
> void foo(void)
> {
>        static int b[1000] = {0};
>        static int c = 0;
> }
> jkacur@linux-ipxk:~/try> gcc foo.c
> jkacur@linux-ipxk:~/try> size a.out
>   text    data     bss     dec     hex filename
>   1203     520    8064    9787    263b a.out
> <----------------------- No difference with the initialization to 0!!!
> jkacur@linux-ipxk:~/try> ls -l a.out
> -rwxr-xr-x 1 jkacur users 11237 2008-08-13 12:26 a.out
> <----------------------- No difference with the initialization to 0!!!
>
>
> Now if we initialize it to a value other than 0 or NULL, then the bss
> is decreased at the expense of the data section, which does indeed
> increase the object size, however checkpatch.pl doesn't complain about
> this. (it is valid to do this)
> jkacur@linux-ipxk:~/try> cat foo.c
> #include <stdio.h>
> #include <stdlib.h>
>
> static int a[1000] = {1};
>
> /* Function Prototype */
> void foo(void);
> int main(void)
> {
>        exit(0);
> }
>
> void foo(void)
> {
>        static int b[1000] = {1};
>        static int c = 1;
> }
> jkacur@linux-ipxk:~/try> gcc foo.c
> jkacur@linux-ipxk:~/try> size a.out
>   text    data     bss     dec     hex filename
>   1203    8568      16    9787    263b a.out
> jkacur@linux-ipxk:~/try> ls -l a.out
> -rwxr-xr-x 1 jkacur users 19301 2008-08-13 12:27 a.out
>

My apologies for not ccing the maintainers of checkpatch the first
time. Attached is a patch to remove the check in case anybody agrees
with me. :)
The patch is against a recently updated git tree.

------=_Part_55673_4800384.1218628232452
Content-Type: text/x-patch; name=remove_static_initialise_error.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjtvpwlx0
Content-Disposition: attachment;
 filename=remove_static_initialise_error.patch

U3ViamVjdDogUmVtb3ZlIHVubmVjZXNzYXJ5IGVycm9yIGFib3V0IGluaXRpYWxpc2luZyBzdGF0
aWNzIHRvIDAgb3IgTlVMTAoKU2lnbmVkLW9mZi1ieTogSm9obiBLYWN1ciA8amthY3VyIGF0IGdt
YWlsIGRvdCBjb20+CgpJbmRleDogbGludXgtMi42L3NjcmlwdHMvY2hlY2twYXRjaC5wbAo9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9zY3JpcHRzL2NoZWNrcGF0Y2gucGwKKysrIGxpbnV4
LTIuNi9zY3JpcHRzL2NoZWNrcGF0Y2gucGwKQEAgLTEzNDEsMTEgKzEzNDEsNiBAQCBzdWIgcHJv
Y2VzcyB7CiAJCQlFUlJPUigiZG8gbm90IGluaXRpYWxpc2UgZXh0ZXJuYWxzIHRvIDAgb3IgTlVM
TFxuIiAuCiAJCQkJJGhlcmVjdXJyKTsKIAkJfQotIyBjaGVjayBmb3Igc3RhdGljIGluaXRpYWxp
c2Vycy4KLQkJaWYgKCRsaW5lID1+IC9ccypzdGF0aWNccy4qPVxzKigwfE5VTEx8ZmFsc2UpXHMq
Oy8pIHsKLQkJCUVSUk9SKCJkbyBub3QgaW5pdGlhbGlzZSBzdGF0aWNzIHRvIDAgb3IgTlVMTFxu
IiAuCi0JCQkJJGhlcmVjdXJyKTsKLQkJfQogCiAjIGNoZWNrIGZvciBuZXcgdHlwZWRlZnMsIG9u
bHkgZnVuY3Rpb24gcGFyYW1ldGVycyBhbmQgc3BhcnNlIGFubm90YXRpb25zCiAjIG1ha2Ugc2Vu
c2UuCg==
------=_Part_55673_4800384.1218628232452--
