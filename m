Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYHMKj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYHMKj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYHMKjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:39:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:60435 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbYHMKjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=XUbxauDkwXcXJv09S1eGtpDl4ZFe2pJIaeyoHP5OW/xQMQRf4XZEVQmc2q/tz9ZHiP
         sUOoWljgn8kmI1E59tIt4jAYqfCpzcDZrEZsqeG8fnC+UXrzEiaJJUP/nl4BEx95pia0
         n0smnfM2RxhFFNofBTVp51kLisUeynULxNCfA=
Message-ID: <520f0cf10808130339r5dd22e12w3477d6bddd545db1@mail.gmail.com>
Date: Wed, 13 Aug 2008 12:39:45 +0200
From: "John Kacur" <jkacur@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: drop overzealous ERROR: do not initialise statics to 0 or NULL from checkpatch.pl
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could we drop this somewhat overzealous "ERROR: do not initialise
statics to 0 or NULL" from checkpatch.pl?

Reasoning:
1. This is not part of Documentation/CodingStyle
2. K&R 2nd.ed do it (pg 83, static int bufp = 0;) The purpose is to
remove access to the bufp from external routines, and to avoid name
conflict)
3. It can be a good form of documentation.
4. It creates a lot of needless code churn to change this kind of
thing for no good reason.
5. It doesn't even change the object size (thus kernel size) to do so.
Demo with user space code.

jkacur@linux-ipxk:~/try> cat foo.c
#include <stdio.h>
#include <stdlib.h>

static int a[1000];

/* Function Prototype */
void foo(void);
int main(void)
{
        exit(0);
}

void foo(void)
{
        static int b[1000];
        static int c;
}
jkacur@linux-ipxk:~/try> gcc foo.c
jkacur@linux-ipxk:~/try> size a.out
   text    data     bss     dec     hex filename
   1203     520    8064    9787    263b a.out
jkacur@linux-ipxk:~/try> ls -l a.out
-rwxr-xr-x 1 jkacur users 11237 2008-08-13 12:26 a.out

Now initialize all the statics to 0 and there will be no difference in
the object size
jkacur@linux-ipxk:~/try> cat foo.c
#include <stdio.h>
#include <stdlib.h>

static int a[1000] = {0};

/* Function Prototype */
void foo(void);
int main(void)
{
        exit(0);
}

void foo(void)
{
        static int b[1000] = {0};
        static int c = 0;
}
jkacur@linux-ipxk:~/try> gcc foo.c
jkacur@linux-ipxk:~/try> size a.out
   text    data     bss     dec     hex filename
   1203     520    8064    9787    263b a.out
<----------------------- No difference with the initialization to 0!!!
jkacur@linux-ipxk:~/try> ls -l a.out
-rwxr-xr-x 1 jkacur users 11237 2008-08-13 12:26 a.out
<----------------------- No difference with the initialization to 0!!!


Now if we initialize it to a value other than 0 or NULL, then the bss
is decreased at the expense of the data section, which does indeed
increase the object size, however checkpatch.pl doesn't complain about
this. (it is valid to do this)
jkacur@linux-ipxk:~/try> cat foo.c
#include <stdio.h>
#include <stdlib.h>

static int a[1000] = {1};

/* Function Prototype */
void foo(void);
int main(void)
{
        exit(0);
}

void foo(void)
{
        static int b[1000] = {1};
        static int c = 1;
}
jkacur@linux-ipxk:~/try> gcc foo.c
jkacur@linux-ipxk:~/try> size a.out
   text    data     bss     dec     hex filename
   1203    8568      16    9787    263b a.out
jkacur@linux-ipxk:~/try> ls -l a.out
-rwxr-xr-x 1 jkacur users 19301 2008-08-13 12:27 a.out
