Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYHTU6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYHTU6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYHTU6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:58:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:57517 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYHTU6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=H6/cSpIjRYV6lw2aeLW2rE4Hmrh+BJtbPPGMQG1QefYjlQmx27+9bU1WBEnT8bxZ8b
         BWao5Gi1fuQ7O3uJm73aeQrg/+pw0EYL64LBG2DSTnmX4N5q8EQqlt8AHVRbvq7LVcVE
         ZXHNBCi3Wjv+qx32dlMyiLQoEahVgSQ3gxapA=
Message-ID: <2c0942db0808201358t1126f4bwd745402f6e9b42d2@mail.gmail.com>
Date: Wed, 20 Aug 2008 13:58:03 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: VolanoMark regression with 2.6.27-rc1
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, adobriyan@gmail.com,
       "Ingo Molnar" <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Aneesh Kumar KV" <aneesh.kumar@linux.vnet.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Chris Friesen" <cfriesen@nortel.com>
In-Reply-To: <1219264236.8651.76.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1912217169.25608.228.camel@ymzhang>
	 <2c0942db0808200929r640b3a1cj33efc56cfd6db9b3@mail.gmail.com>
	 <1219252901.8651.63.camel@twins>
	 <200808210355.55597.nickpiggin@yahoo.com.au>
	 <2c0942db0808201115v3025e5f6r6c882783fa9e29f3@mail.gmail.com>
	 <1219264236.8651.76.camel@twins>
X-Google-Sender-Auth: b35ac780d8df866c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 1:30 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Nick is right, try:
>
> int main(int argc, char **argv)
> {
>        unsigned int x = 7, y = 5;
>        printf("%d\n", avg(x,y));
>        return 0;
> }
>
> It fails because 5-7 = -2, which needs a signed division or sign
> extending right shift.
>
> we'd need something like:
>
> #define avg(x, y) ({                            \
>        typeof(x) _avg1 = (x);                  \
>        typeof(y) _avg2 = (y);                  \
>        (void) (&_avg1 == &_avg2);              \
>        _avg1 + (signed typeof(x))(_avg2 - _avg1)/2; })
>
> except that typeof() doesn't work that way.
>
> #define avg(x, y) ({                            \
>        typeof(x) _avg1 = (x);                  \
>        typeof(y) _avg2 = (y);                  \
>        (void) (&_avg1 == &_avg2);              \
>        _avg1 + (long)(_avg2 - _avg1)/2; })
>
> works for the above example, but when I make it long long, so as to
> match the longest supported type, it goes boom again - for as of yet
> unknown reasons.

I think you'd want to cast it with a (signed) instead? as in:

#include <stdio.h>

#define avg(x, y) ({            \
       typeof(x) _x = (x);      \
       typeof(y) _y = (y);      \
       (void) (&_x == &_y);     \
       _x + (signed)(_y - _x)/2; })

int main (void) {
        unsigned long long a=7,b=5;

        printf("%d %d\n", avg(a,b), avg(b,a));
}

...which works here, for me, but hey, I managed to goof up my other
test case, so take it for a spin.

Ray
