Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZJ1AIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZJ1AIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 20:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbZJ1AIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 20:08:47 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35192 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541AbZJ1AIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 20:08:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:x-age:x-location
         :x-os:x-face:content-type:content-transfer-encoding;
        b=IHqnghA9B+KgAsGiqg0bkOLQymu/tqpAciZnURg8mePGEGdLL1A/uN118F/yTzkePB
         tWO1xOKVE3Vy9zQo/uoFeOF4615IonLnUC4EzNbxo+VtymZIoe1TbnGDrevcXa2mCkVW
         nPeLXCWuYAlRcEl5I+hUOf1LDCoXOr7oP14LE=
Message-ID: <4AE78B8F.9050201@gmail.com>
Date: Wed, 28 Oct 2009 01:08:47 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090701 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
References: <hav57c$rso$1@ger.gmane.org> <20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com> <hb2cfu$r08$2@ger.gmane.org> <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com> <4ADE3121.6090407@gmail.com> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com> <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com>
X-Age: 25
X-Location: Lovran, Croatia
X-OS: Debian GNU/Linux
X-Face: +Lg7^E:?#]P.Y{N@61yW{aY#>fRcOE6MMqgAM|Kwk"fK!y!i4+h6&?E`Jt@uame[-SLu#*<fGtMmVfh8qo,"kJ'ql^Ni?]l|ax{fvvmD<k:2w^e(y8J2YWO`M=u17OWli}Rf^e:|w2]LulgE(:u0|}mNBZFid[YEWAC>?k:)dZv<!'a)N0b=LFDZKY!!@[%mmVO-7y`Nkj?{<C6rm9Uz$EXu;0I<PubM.Po|vlT.2&vPkJG07G.l0Ty)B/dR0k:KU<;?+WAR\f_ms2b~i"g@e}a)i1N$WLBa{vBoDs4!}k\g?lItt=|]=M{Fm@ce|^6PXq&
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:

> There's advantages to either approach, but it depends on the contextual 
> goal of the oom killer when it's called: kill a rogue task that is 
> allocating more memory than expected,

But it is wrong at counting allocated memory!
Come on, it kills /usr/lib/icedove/run-mozilla.sh. Parent, a shell
script, instead of its child(s) which allocated memory. Look, "test"
allocates some (0.1GB) memory, and you have:

% cat test.sh

#!/bin/sh
./test&
./test&
./test&
./test

% perl check_badness.pl|sort -n|g test

26511   7884    test
26511   7885    test
26511   7886    test
26511   7887    test
53994   7883    test.sh

// great, so test.sh "is" the bad ass, ok, emulate OOMK:

% kill -9 7883

// did we kill "a rogue task"

% perl check_badness.pl|sort -n|g test

26511   7884    test
26511   7885    test
26511   7886    test
26511   7887    test

// nooo, they are still alive and eating our memory!

QED by newbie. ;)

> or kill a task that will free the most memory.

.

