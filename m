Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZJEPIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZJEPIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbZJEPIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:08:44 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:43258 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbZJEPIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:08:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bE1bI7+PGDVQT8cm0/pugSL85X3UYpGNLS8e2mQTSYl4ohucH0SnmigqDzl8CD47Hq
         vsQaXBsIfJQzIAILLTH4bOLe+tkUaCkqm6Pye7evGTCXVx2wcARWppL2SDn4fDsYhd7q
         6qpsrAqPMOy9Qgz0xsjUN/82f49txq8nWfspQ=
MIME-Version: 1.0
In-Reply-To: <20091004205955.GM26573@kernel.dk>
References: <4e5e476b0910041354o54c95626g974264976adaf53c@mail.gmail.com>
	 <20091004205955.GM26573@kernel.dk>
Date: Mon, 5 Oct 2009 17:08:04 +0200
Message-ID: <4e5e476b0910050808k3a26aad8r19a145fc60e1da6b@mail.gmail.com>
Subject: Re: bug in elevator/cfq regarding start_time?
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 4, 2009 at 10:59 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> Good spotting! So we can either add the same copy in cfq, or we can just
> move the ->start_time check and assignment in attempt_merge() to post
> the elv_merge_requests() call. I think the latter would work fine, but
> I'll check and fix tomorrow.

I think there is still something buggy regarding those timestamps.
I added the following code:
               struct request *rq = rq_entry_fifo(cfqq->fifo.next);
                rb_key = jiffies;
                printk(KERN_INFO "Queue %p added at %lu with
start_time %lu, fifo_time %lu\n", cfqq, rb_key, rq->start_time,
rq_fifo_time(rq));
in the (!add_front) path of cfq_service_tree_add, and I get the puzzling:

[ 2892.252866] io scheduler cfq registered
[ 2900.785179] Queue f36a2700 added at 2600784 with start_time 0, fifo_time 0
[ 2900.785754] Queue f36a2dc0 added at 2600785 with start_time 0, fifo_time 0
[ 2900.802975] Queue f36a2700 added at 2600802 with start_time 0,
fifo_time 2600902
[ 2900.808695] Queue f36a2700 added at 2600808 with start_time 0,
fifo_time 2600902
[ 2900.813437] Queue f36a2700 added at 2600813 with start_time 0,
fifo_time 2600902
[ 2900.824576] Queue f36a2700 added at 2600824 with start_time 0,
fifo_time 2600902
[ 2900.835112] Queue f36a2694 added at 2600835 with start_time 0, fifo_time 0
[ 2900.836416] Queue f36a2700 added at 2600836 with start_time 0,
fifo_time 2600902
[ 2900.846350] Queue f36a2700 added at 2600846 with start_time 0,
fifo_time 2600902
[ 2900.856558] Queue f36a2700 added at 2600856 with start_time 0,
fifo_time 2600902
[ 2900.860327] Queue f36a2700 added at 2600860 with start_time 0,
fifo_time 2600902
[ 2900.868702] Queue f36a2700 added at 2600868 with start_time 0,
fifo_time 2600902
[ 2900.875067] Queue f36a2700 added at 2600875 with start_time 0,
fifo_time 2600902
[ 2900.887291] Queue f36a2700 added at 2600887 with start_time 0,
fifo_time 2600902
[ 2900.893159] Queue f36a2700 added at 2600893 with start_time 0,
fifo_time 2600902
[ 2900.899166] Queue f36a2700 added at 2600899 with start_time 0,
fifo_time 2600902
[ 2900.909187] Queue f36a2700 added at 2600909 with start_time 0,
fifo_time 2600902
[ 2900.918176] Queue f36a2dc0 added at 2600918 with start_time 0,
fifo_time 2601018
[ 2900.931307] Queue f36a2dc0 added at 2600931 with start_time 0,
fifo_time 2601018
[ 2900.947928] Queue f36a2dc0 added at 2600947 with start_time 0,
fifo_time 2601018
[ 2900.958411] Queue f36a2dc0 added at 2600958 with start_time 0,
fifo_time 2601018
[ 2900.972069] Queue f36a2694 added at 2600972 with start_time 1,
fifo_time 2601071
[ 2900.972091] Queue f36a2694 added at 2600972 with start_time 1,
fifo_time 2601071
[ 2900.972131] Queue f36a2694 added at 2600972 with start_time 1,
fifo_time 2601071
[ 2901.072721] Queue f36a2694 added at 2601072 with start_time
2601006, fifo_time 2601131
[ 2901.088532] Queue f36a2dc0 added at 2601088 with start_time 0,
fifo_time 2601188
[ 2901.093024] Queue f36a2dc0 added at 2601092 with start_time 0,
fifo_time 2601188
[ 2901.102174] Queue f36a2dc0 added at 2601102 with start_time 0,
fifo_time 2601188
[ 2901.108286] Queue f36a2dc0 added at 2601108 with start_time 0,
fifo_time 2601188
[ 2901.114145] Queue f36a2dc0 added at 2601114 with start_time 0,
fifo_time 2601188
[ 2901.126528] Queue f36a2dc0 added at 2601126 with start_time 0,
fifo_time 2601188
[ 2901.138521] Queue f36a2dc0 added at 2601138 with start_time 0,
fifo_time 2601188
[ 2901.145924] Queue f36a2dc0 added at 2601145 with start_time 0,
fifo_time 2601188
[ 2901.156286] Queue f36a2dc0 added at 2601156 with start_time 0,
fifo_time 2601188
[ 2901.158932] Queue f36a2dc0 added at 2601158 with start_time 0,
fifo_time 2601188
[ 2901.170278] Queue f36a2dc0 added at 2601170 with start_time 0,
fifo_time 2601188
[ 2901.178530] Queue f36a2dc0 added at 2601178 with start_time 0,
fifo_time 2601188
[ 2901.188418] Queue f36a2dc0 added at 2601188 with start_time 0,
fifo_time 2601188
[ 2901.201399] Queue f36a2700 added at 2601201 with start_time 0,
fifo_time 2601301
[ 2901.211661] Queue f36a2700 added at 2601211 with start_time 0,
fifo_time 2601301
[ 2901.221408] Queue f36a2700 added at 2601221 with start_time 0,
fifo_time 2601301
[ 2901.228884] Queue f36a2700 added at 2601228 with start_time 0,
fifo_time 2601301
[ 2901.240536] Queue f36a2700 added at 2601240 with start_time 0,
fifo_time 2601301
[ 2901.248675] Queue f36a2700 added at 2601248 with start_time 0,
fifo_time 2601301
[ 2901.254162] Queue f36a2700 added at 2601254 with start_time 0,
fifo_time 2601301
[ 2901.266267] Queue f36a2700 added at 2601266 with start_time 0,
fifo_time 2601301
[ 2901.274044] Queue f36a2700 added at 2601274 with start_time 0,
fifo_time 2601301
[ 2901.276767] Queue f36a2700 added at 2601276 with start_time 0,
fifo_time 2601301
[ 2901.287135] Queue f36a2700 added at 2601287 with start_time 0,
fifo_time 2601301
[ 2901.294752] Queue f36a2700 added at 2601294 with start_time 0,
fifo_time 2601301
[ 2901.296890] Queue f36a2700 added at 2601296 with start_time 0,
fifo_time 2601301
[ 2901.309032] Queue f36a2700 added at 2601309 with start_time 0,
fifo_time 2601301
[ 2901.418604] Queue f36a2694 added at 2601418 with start_time
2601407, fifo_time 2601532
[ 2901.429552] Queue f36a2dc0 added at 2601429 with start_time 0,
fifo_time 2601529
[ 2901.442382] Queue f36a2dc0 added at 2601442 with start_time 0,
fifo_time 2601529
[ 2901.451290] Queue f36a2dc0 added at 2601451 with start_time 0,
fifo_time 2601529
[ 2901.457910] Queue f36a2dc0 added at 2601457 with start_time 0,
fifo_time 2601529
[ 2901.470146] Queue f36a2dc0 added at 2601470 with start_time 0,
fifo_time 2601529
[ 2901.476499] Queue f36a2dc0 added at 2601476 with start_time 0,
fifo_time 2601529
[ 2901.484636] Queue f36a2dc0 added at 2601484 with start_time 0,
fifo_time 2601529
[ 2901.493999] Queue f36a2dc0 added at 2601493 with start_time 0,
fifo_time 2601529
[ 2901.501657] Queue f36a2dc0 added at 2601501 with start_time 0,
fifo_time 2601529
[ 2901.505033] Queue f36a2dc0 added at 2601504 with start_time 0,
fifo_time 2601529
[ 2901.511003] Queue f36a2dc0 added at 2601510 with start_time 0,
fifo_time 2601529
[ 2901.516789] Queue f36a2dc0 added at 2601516 with start_time 0,
fifo_time 2601529
[ 2901.526158] Queue f36a2dc0 added at 2601526 with start_time 0,
fifo_time 2601529
[ 2901.536981] Queue f36a2dc0 added at 2601536 with start_time 0,
fifo_time 2601529
[ 2901.551037] Queue f36a2700 added at 2601551 with start_time 0,
fifo_time 2601650
[ 2901.562150] Queue f36a2700 added at 2601562 with start_time 0,
fifo_time 2601650
[ 2901.567243] Queue f36a2700 added at 2601567 with start_time 0,
fifo_time 2601650
[ 2901.574150] Queue f36a2700 added at 2601574 with start_time 0,
fifo_time 2601650
[ 2901.578523] Queue f36a2700 added at 2601578 with start_time 0,
fifo_time 2601650
[ 2901.588526] Queue f36a2700 added at 2601588 with start_time 0,
fifo_time 2601650
[ 2901.615982] Queue f36a2694 added at 2601615 with start_time 1,
fifo_time 2601698
[ 2901.701074] Queue f36a2694 added at 2601701 with start_time
2601690, fifo_time 2601815
[ 2901.710993] Queue f36a2700 added at 2601710 with start_time 0,
fifo_time 2601810
[ 2901.720751] Queue f36a2700 added at 2601720 with start_time 0,
fifo_time 2601810
[ 2901.728237] Queue f36a2700 added at 2601728 with start_time 0,
fifo_time 2601810
[ 2901.739622] Queue f36a2700 added at 2601739 with start_time 0,
fifo_time 2601810
[ 2901.747369] Queue f36a2700 added at 2601747 with start_time 0,
fifo_time 2601810
[ 2901.756372] Queue f36a2700 added at 2601756 with start_time 0,
fifo_time 2601810
[ 2901.767507] Queue f36a2700 added at 2601767 with start_time 0,
fifo_time 2601810
[ 2901.773621] Queue f36a2700 added at 2601773 with start_time 0,
fifo_time 2601810
[ 2901.784752] Queue f36a2700 added at 2601784 with start_time 0,
fifo_time 2601810
[ 2901.791117] Queue f36a2700 added at 2601791 with start_time 0,
fifo_time 2601810
[ 2901.800506] Queue f36a2700 added at 2601800 with start_time 0,
fifo_time 2601810
[ 2901.806108] Queue f36a2700 added at 2601806 with start_time 0,
fifo_time 2601810
[ 2901.816634] Queue f36a2700 added at 2601816 with start_time 0,
fifo_time 2601810
[ 2901.830011] Queue f36a2dc0 added at 2601829 with start_time 0,
fifo_time 2601929
[ 2901.841172] Queue f36a2dc0 added at 2601841 with start_time 0,
fifo_time 2601929
[ 2901.849320] Queue f36a2dc0 added at 2601849 with start_time 0,
fifo_time 2601929
[ 2901.859641] Queue f36a2dc0 added at 2601859 with start_time 0,
fifo_time 2601929
[ 2901.868768] Queue f36a2dc0 added at 2601868 with start_time 0,
fifo_time 2601929
[ 2901.880052] Queue f36a2dc0 added at 2601880 with start_time 0,
fifo_time 2601929
[ 2901.885278] Queue f36a2dc0 added at 2601885 with start_time 0,
fifo_time 2601929
[ 2901.893273] Queue f36a2dc0 added at 2601893 with start_time 0,
fifo_time 2601929
[ 2901.900390] Queue f36a2dc0 added at 2601900 with start_time 0,
fifo_time 2601929
[ 2901.910893] Queue f36a2dc0 added at 2601910 with start_time 0,
fifo_time 2601929
[ 2901.917888] Queue f36a2dc0 added at 2601917 with start_time 0,
fifo_time 2601929
[ 2901.926031] Queue f36a2dc0 added at 2601926 with start_time 0,
fifo_time 2601929
[ 2901.932151] Queue f36a2dc0 added at 2601932 with start_time 0,
fifo_time 2601929
[ 2901.998417] Queue f36a2694 added at 2601998 with start_time 1,
fifo_time 2602045
[ 2902.047930] Queue f36a2694 added at 2602047 with start_time
2602037, fifo_time 2602162
[ 2902.056985] Queue f36a2700 added at 2602056 with start_time 0, fifo_time 0
[ 2902.148427] Queue f36a2694 added at 2602148 with start_time 1,
fifo_time 2602157
[ 2902.157051] Queue f36a2694 added at 2602157 with start_time
2602148, fifo_time 2602273
[ 2902.172470] Queue f36a2dc0 added at 2602172 with start_time 0,
fifo_time 2602272
[ 2902.182978] Queue f36a2dc0 added at 2602182 with start_time 0,
fifo_time 2602272
[ 2902.197989] Queue f36a2dc0 added at 2602197 with start_time 0,
fifo_time 2602272
[ 2902.208464] Queue f36a2dc0 added at 2602208 with start_time 0,
fifo_time 2602272
[ 2902.219344] Queue f36a2dc0 added at 2602219 with start_time 0,
fifo_time 2602272
[ 2902.225239] Queue f36a2dc0 added at 2602225 with start_time 0,
fifo_time 2602272
[ 2902.232345] Queue f36a2dc0 added at 2602232 with start_time 0,
fifo_time 2602272
[ 2902.238079] Queue f36a2dc0 added at 2602238 with start_time 0,
fifo_time 2602272
[ 2902.245393] Queue f36a2dc0 added at 2602245 with start_time 0,
fifo_time 2602272
[ 2902.251997] Queue f36a2dc0 added at 2602251 with start_time 0,
fifo_time 2602272
[ 2902.259211] Queue f36a2dc0 added at 2602259 with start_time 0,
fifo_time 2602272
[ 2902.271594] Queue f36a2dc0 added at 2602271 with start_time 0,
fifo_time 2602272
[ 2902.278868] Queue f36a2dc0 added at 2602278 with start_time 0,
fifo_time 2602272
[ 2902.293854] Queue f36a2700 added at 2602293 with start_time 0,
fifo_time 2602393
[ 2902.300962] Queue f36a2700 added at 2602300 with start_time 0,
fifo_time 2602393
[ 2902.305826] Queue f36a2700 added at 2602305 with start_time 0,
fifo_time 2602393
[ 2902.310847] Queue f36a2700 added at 2602310 with start_time 0,
fifo_time 2602393
[ 2902.317337] Queue f36a2700 added at 2602317 with start_time 0,
fifo_time 2602393
[ 2902.325590] Queue f36a2700 added at 2602325 with start_time 0,
fifo_time 2602393
[ 2902.335340] Queue f36a2700 added at 2602335 with start_time 0,
fifo_time 2602393
[ 2902.347267] Queue f36a2700 added at 2602347 with start_time 0,
fifo_time 2602393
[ 2902.356614] Queue f36a2700 added at 2602356 with start_time 0,
fifo_time 2602393
[ 2902.362082] Queue f36a2700 added at 2602362 with start_time 0,
fifo_time 2602393
[ 2902.375340] Queue f36a2700 added at 2602375 with start_time 0,
fifo_time 2602393
[ 2902.391207] Queue f36a2700 added at 2602391 with start_time 0,
fifo_time 2602393
[ 2902.399966] Queue f36a2700 added at 2602399 with start_time 0,
fifo_time 2602393
[ 2902.515413] Queue f36a2694 added at 2602515 with start_time
2602504, fifo_time 2602629
[ 2902.531346] Queue f36a2dc0 added at 2602531 with start_time 0,
fifo_time 2602631
[ 2902.536692] Queue f36a2dc0 added at 2602536 with start_time 0,
fifo_time 2602631
[ 2902.540470] Queue f36a2dc0 added at 2602540 with start_time 0,
fifo_time 2602631
[ 2902.546630] Queue f36a2dc0 added at 2602546 with start_time 0,
fifo_time 2602631
[ 2902.551987] Queue f36a2dc0 added at 2602551 with start_time 0,
fifo_time 2602631
[ 2902.558467] Queue f36a2dc0 added at 2602558 with start_time 0,
fifo_time 2602631
[ 2902.566719] Queue f36a2dc0 added at 2602566 with start_time 0,
fifo_time 2602631
[ 2902.576452] Queue f36a2dc0 added at 2602576 with start_time 0,
fifo_time 2602631
[ 2902.585818] Queue f36a2dc0 added at 2602585 with start_time 0,
fifo_time 2602631
[ 2902.591323] Queue f36a2dc0 added at 2602591 with start_time 0,
fifo_time 2602631
[ 2902.596935] Queue f36a2dc0 added at 2602596 with start_time 0,
fifo_time 2602631
[ 2902.604066] Queue f36a2dc0 added at 2602604 with start_time 0,
fifo_time 2602631
[ 2902.612820] Queue f36a2dc0 added at 2602612 with start_time 0,
fifo_time 2602631
[ 2902.619764] Queue f36a2dc0 added at 2602619 with start_time 0,
fifo_time 2602631
[ 2902.623096] Queue f36a2dc0 added at 2602623 with start_time 0,
fifo_time 2602631
[ 2902.634605] Queue f36a2dc0 added at 2602634 with start_time 0,
fifo_time 2602631
[ 2902.646341] Queue f36a2700 added at 2602646 with start_time 0,
fifo_time 2602746
[ 2902.654590] Queue f36a2700 added at 2602654 with start_time 0,
fifo_time 2602746
[ 2902.661063] Queue f36a2700 added at 2602661 with start_time 0,
fifo_time 2602746
[ 2902.668204] Queue f36a2700 added at 2602668 with start_time 0,
fifo_time 2602746
[ 2902.686868] Queue f36a2694 added at 2602686 with start_time 1,
fifo_time 2602777
[ 2902.777273] Queue f36a2694 added at 2602777 with start_time
2602766, fifo_time 2602891
[ 2902.791832] Queue f36a2700 added at 2602791 with start_time 0,
fifo_time 2602891
[ 2902.804069] Queue f36a2700 added at 2602804 with start_time 0,
fifo_time 2602891
[ 2902.816080] Queue f36a2700 added at 2602816 with start_time 0,
fifo_time 2602891
[ 2902.822437] Queue f36a2700 added at 2602822 with start_time 0,
fifo_time 2602891
[ 2902.827809] Queue f36a2700 added at 2602827 with start_time 0,
fifo_time 2602891
[ 2902.835191] Queue f36a2700 added at 2602835 with start_time 0,
fifo_time 2602891
[ 2902.845092] Queue f36a2700 added at 2602845 with start_time 0,
fifo_time 2602891
[ 2902.853156] Queue f36a2700 added at 2602852 with start_time 0,
fifo_time 2602891
[ 2902.860446] Queue f36a2700 added at 2602860 with start_time 0,
fifo_time 2602891
[ 2902.869308] Queue f36a2700 added at 2602869 with start_time 0,
fifo_time 2602891
[ 2902.877688] Queue f36a2700 added at 2602877 with start_time 0,
fifo_time 2602891
[ 2902.890431] Queue f36a2700 added at 2602890 with start_time 0,
fifo_time 2602891
[ 2902.896071] Queue f36a2700 added at 2602896 with start_time 0,
fifo_time 2602891
[ 2902.907181] Queue f36a2dc0 added at 2602907 with start_time 0,
fifo_time 2603007
[ 2902.917954] Queue f36a2dc0 added at 2602917 with start_time 0,
fifo_time 2603007
[ 2902.923808] Queue f36a2dc0 added at 2602923 with start_time 0,
fifo_time 2603007
[ 2902.932822] Queue f36a2dc0 added at 2602932 with start_time 0,
fifo_time 2603007
[ 2902.937797] Queue f36a2dc0 added at 2602937 with start_time 0,
fifo_time 2603007
[ 2902.946325] Queue f36a2dc0 added at 2602946 with start_time 0,
fifo_time 2603007
[ 2902.958563] Queue f36a2dc0 added at 2602958 with start_time 0,
fifo_time 2603007
[ 2902.968192] Queue f36a2dc0 added at 2602968 with start_time 0,
fifo_time 2603007
[ 2902.973697] Queue f36a2dc0 added at 2602973 with start_time 0,
fifo_time 2603007
[ 2902.980952] Queue f36a2dc0 added at 2602980 with start_time 0,
fifo_time 2603007
[ 2902.990088] Queue f36a2dc0 added at 2602990 with start_time 0,
fifo_time 2603007
[ 2903.000123] Queue f36a2dc0 added at 2603000 with start_time 0,
fifo_time 2603007
[ 2903.009221] Queue f36a2dc0 added at 2603009 with start_time 0,
fifo_time 2603007
[ 2903.063339] Queue f36a2694 added at 2603063 with start_time 1,
fifo_time 2603119
[ 2903.121501] Queue f36a2694 added at 2603121 with start_time
2603110, fifo_time 2603235
[ 2903.135307] Queue f36a2700 added at 2603135 with start_time 0,
fifo_time 2603235
[ 2903.143354] Queue f36a2700 added at 2603143 with start_time 0,
fifo_time 2603235
[ 2903.153077] Queue f36a2700 added at 2603153 with start_time 0,
fifo_time 2603235
[ 2903.162585] Queue f36a2700 added at 2603162 with start_time 0,
fifo_time 2603235
[ 2903.226085] Queue f36a2694 added at 2603226 with start_time 1,
fifo_time 2603263
[ 2903.264869] Queue f36a2694 added at 2603264 with start_time
2603254, fifo_time 2603379
[ 2903.279694] Queue f36a2dc0 added at 2603279 with start_time 0,
fifo_time 2603379
[ 2903.285062] Queue f36a2dc0 added at 2603285 with start_time 0,
fifo_time 2603379
[ 2903.296662] Queue f36a2dc0 added at 2603296 with start_time 0,
fifo_time 2603379
[ 2903.303988] Queue f36a2dc0 added at 2603303 with start_time 0,
fifo_time 2603379
[ 2903.316188] Queue f36a2dc0 added at 2603316 with start_time 0,
fifo_time 2603379
[ 2903.323045] Queue f36a2dc0 added at 2603322 with start_time 0,
fifo_time 2603379
[ 2903.328795] Queue f36a2dc0 added at 2603328 with start_time 0,
fifo_time 2603379
[ 2903.334688] Queue f36a2dc0 added at 2603334 with start_time 0,
fifo_time 2603379
[ 2903.346453] Queue f36a2dc0 added at 2603346 with start_time 0,
fifo_time 2603379
[ 2903.358062] Queue f36a2dc0 added at 2603358 with start_time 0,
fifo_time 2603379
[ 2903.363410] Queue f36a2dc0 added at 2603363 with start_time 0,
fifo_time 2603379
[ 2903.369163] Queue f36a2dc0 added at 2603369 with start_time 0,
fifo_time 2603379
[ 2903.375191] Queue f36a2dc0 added at 2603375 with start_time 0,
fifo_time 2603379
[ 2903.389201] Queue f36a2dc0 added at 2603389 with start_time 0,
fifo_time 2603379
[ 2903.398676] Queue f36a2700 added at 2603398 with start_time 0,
fifo_time 2603498
[ 2903.404920] Queue f36a2700 added at 2603404 with start_time 0,
fifo_time 2603498
[ 2903.412293] Queue f36a2700 added at 2603412 with start_time 0,
fifo_time 2603498
[ 2903.421186] Queue f36a2700 added at 2603421 with start_time 0,
fifo_time 2603498
[ 2903.426661] Queue f36a2700 added at 2603426 with start_time 0,
fifo_time 2603498
[ 2903.439177] Queue f36a2700 added at 2603438 with start_time 0,
fifo_time 2603498
[ 2903.446128] Queue f36a2700 added at 2603445 with start_time 0,
fifo_time 2603498
[ 2903.453804] Queue f36a2700 added at 2603453 with start_time 0,
fifo_time 2603498

i.e. start_time is almost always small or 0. fifo_time is usually
correct, but may be 0 as well.
unfortunately, this time I have no clue on the possible cause.

Corrado

>
> --
> Jens Axboe
>
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
