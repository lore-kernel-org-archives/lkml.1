Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbYDDPAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbYDDPAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758913AbYDDO77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:59:59 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59038 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758767AbYDDO76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:59:58 -0400
Message-ID: <47F6424F.9010405@bull.net>
Date: Fri, 04 Apr 2008 16:59:27 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: Scalability requirements for sysv ipc (+namespaces broken with
 SEM_UNDO)
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net>	 <47E3B924.3000304@colorfullife.com>	 <20080321141339.GB9618@linux.vnet.ibm.com>	 <47E3DD8C.4000904@colorfullife.com>	 <1206164608.3659.11.camel@marge.simson.net>	 <47E4DB06.3020003@colorfullife.com>	 <1206186832.4545.1.camel@marge.simson.net>	 <47E51637.8060102@colorfullife.com>  <47E55945.10109@colorfullife.com>	 <1206460206.4414.21.camel@marge.simson.net>	 <47EF9FC2.3050901@colorfullife.com> <1206897488.4593.11.camel@marge.simson.net>
In-Reply-To: <1206897488.4593.11.camel@marge.simson.net>
Content-Type: multipart/mixed;
 boundary="------------080304050300080309060507"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080304050300080309060507
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Mike Galbraith wrote:
> On Sun, 2008-03-30 at 16:12 +0200, Manfred Spraul wrote:
> 
>>Mike Galbraith wrote:
>>
>>>On Sat, 2008-03-22 at 20:08 +0100, Manfred Spraul wrote:
>>>
>>>  
>>>
>>>>just the normal performance of 2.6.25-rc3 is abyssimal, 55 to 60% slower 
>>>>than 2.6.18.8:
>>>>    
>>>
>>>After manually reverting 3e148c79938aa39035669c1cfa3ff60722134535,
>>>2.6.25.git scaled linearly
>>
>>We can't just revert that patch: with IDR, a global lock is mandatory :-(
>>We must either revert the whole idea of using IDR or live with the 
>>reduced scalability.
> 
> 
> Yeah, I looked at the problem, but didn't know what the heck to do about
> it, so just grabbed my axe to verify/quantify.
> 
> 
>>Actually, there are further bugs: the undo structures are not 
>>namespace-aware, thus semop with SEM_UNDO, unshare, create new array 
>>with same id, but more semaphores, another semop with SEM_UNDO will 
>>corrupt kernel memory :-(
>>I'll try to clean up the bugs first, then I'll look at the scalability 
>>again.
> 
> 
> Great!
> 
> 	-Mike
> 
> 
> 
> 

I could get better results with the following solution:
wrote an RCU-based idr api (layers allocation is managed similarly to 
the radix-tree one)

Using it in the ipc code makes me get rid of the read lock taken in 
ipc_lock() (the one introduced in 3e148c79938aa39035669c1cfa3ff60722134535).

You'll find the results in attachment (kernel is 2.6.25-rc3-mm1).
output.25_rc3_mm1.ref.8  --> pmsg output for the 2.6.25-rc3-mm1
plot.25_rc3_mm1.ref.8    --> previous file results for use by gnuplot
output.25_rc3_mm1.ridr.8 --> pmsg output for the 2.6.25-rc3-mm1
                              + rcu-based idrs
plot.25_rc3_mm1.ridr.8   --> previous file results for use by gnuplot


I think I should be able to send a patch next week. It is presently an 
uggly code: I copied idr.c and idr.h into ridr.c and ridr.h to go fast, 
so didn't do any code factorization.

Regards
Nadia




--------------080304050300080309060507
Content-Type: text/x-troff-man;
 name="output.25_rc3_mm1.ref.8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="output.25_rc3_mm1.ref.8"

pmsg [nr queues] [timeout]
Using 1 queues/cpus (2 threads) for 5 seconds.
thread 0: sysvmsg        0 type 1 bound to 0001h
thread 1: sysvmsg        0 type 0 bound to 0001h
Result matrix:
  Thread   0:   488650       1:   488650
Total: 977300
pmsg [nr queues] [timeout]
Using 2 queues/cpus (4 threads) for 5 seconds.
thread 0: sysvmsg    32768 type 1 bound to 0001h
thread 1: sysvmsg    65537 type 1 bound to 0002h
thread 3: sysvmsg    65537 type 0 bound to 0002h
thread 2: sysvmsg    32768 type 0 bound to 0001h
Result matrix:
  Thread   0:   223991       2:   223991
  Thread   1:   225588       3:   225588
Total: 899158
pmsg [nr queues] [timeout]
Using 3 queues/cpus (6 threads) for 5 seconds.
thread 0: sysvmsg    98304 type 1 bound to 0001h
thread 1: sysvmsg   131073 type 1 bound to 0002h
thread 2: sysvmsg   163842 type 1 bound to 0004h
thread 5: sysvmsg   163842 type 0 bound to 0004h
thread 4: sysvmsg   131073 type 0 bound to 0002h
thread 3: sysvmsg    98304 type 0 bound to 0001h
Result matrix:
  Thread   0:   183407       3:   183407
  Thread   1:   184030       4:   184030
  Thread   2:   357875       5:   357876
Total: 1450625
pmsg [nr queues] [timeout]
Using 4 queues/cpus (8 threads) for 5 seconds.
thread 0: sysvmsg   196608 type 1 bound to 0001h
thread 1: sysvmsg   229377 type 1 bound to 0002h
thread 2: sysvmsg   262146 type 1 bound to 0004h
thread 3: sysvmsg   294915 type 1 bound to 0008h
thread 5: sysvmsg   229377 type 0 bound to 0002h
thread 6: sysvmsg   262146 type 0 bound to 0004h
thread 7: sysvmsg   294915 type 0 bound to 0008h
thread 4: sysvmsg   196608 type 0 bound to 0001h
Result matrix:
  Thread   0:   166911       4:   166912
  Thread   1:   159281       5:   159281
  Thread   2:   166024       6:   166024
  Thread   3:   167440       7:   167440
Total: 1319313
pmsg [nr queues] [timeout]
Using 5 queues/cpus (10 threads) for 5 seconds.
thread 0: sysvmsg   327680 type 1 bound to 0001h
thread 2: sysvmsg   393218 type 1 bound to 0004h
thread 3: sysvmsg   425987 type 1 bound to 0008h
thread 4: sysvmsg   458756 type 1 bound to 0010h
thread 9: sysvmsg   458756 type 0 bound to 0010h
thread 6: sysvmsg   360449 type 0 bound to 0002h
thread 8: sysvmsg   425987 type 0 bound to 0008h
thread 7: sysvmsg   393218 type 0 bound to 0004h
thread 1: sysvmsg   360449 type 1 bound to 0002h
thread 5: sysvmsg   327680 type 0 bound to 0001h
Result matrix:
  Thread   0:    39740       5:    39740
  Thread   1:    40399       6:    40399
  Thread   2:    40326       7:    40327
  Thread   3:    39290       8:    39290
  Thread   4:    68684       9:    68685
Total: 456880
pmsg [nr queues] [timeout]
Using 6 queues/cpus (12 threads) for 5 seconds.
thread 0: sysvmsg   491520 type 1 bound to 0001h
thread 1: sysvmsg   524289 type 1 bound to 0002h
thread 2: sysvmsg   557058 type 1 bound to 0004h
thread 3: sysvmsg   589827 type 1 bound to 0008h
thread 4: sysvmsg   622596 type 1 bound to 0010h
thread 5: sysvmsg   655365 type 1 bound to 0020h
thread 6: sysvmsg   491520 type 0 bound to 0001h
thread 11: sysvmsg   655365 type 0 bound to 0020h
thread 10: sysvmsg   622596 type 0 bound to 0010h
thread 8: sysvmsg   557058 type 0 bound to 0004h
thread 9: sysvmsg   589827 type 0 bound to 0008h
thread 7: sysvmsg   524289 type 0 bound to 0002h
Result matrix:
  Thread   0:    27901       6:    27901
  Thread   1:    28554       7:    28555
  Thread   2:    28471       8:    28472
  Thread   3:    28015       9:    28016
  Thread   4:    28213      10:    28213
  Thread   5:    28396      11:    28396
Total: 339103
pmsg [nr queues] [timeout]
Using 7 queues/cpus (14 threads) for 5 seconds.
thread 0: sysvmsg   688128 type 1 bound to 0001h
thread 1: sysvmsg   720897 type 1 bound to 0002h
thread 2: sysvmsg   753666 type 1 bound to 0004h
thread 3: sysvmsg   786435 type 1 bound to 0008h
thread 4: sysvmsg   819204 type 1 bound to 0010h
thread 5: sysvmsg   851973 type 1 bound to 0020h
thread 6: sysvmsg   884742 type 1 bound to 0040h
thread 13: sysvmsg   884742 type 0 bound to 0040h
thread 7: sysvmsg   688128 type 0 bound to 0001h
thread 11: sysvmsg   819204 type 0 bound to 0010h
thread 12: sysvmsg   851973 type 0 bound to 0020h
thread 8: sysvmsg   720897 type 0 bound to 0002h
thread 10: sysvmsg   786435 type 0 bound to 0008h
thread 9: sysvmsg   753666 type 0 bound to 0004h
Result matrix:
  Thread   0:    12201       7:    12201
  Thread   1:    12451       8:    12452
  Thread   2:    12345       9:    12345
  Thread   3:    12277      10:    12278
  Thread   4:    12259      11:    12259
  Thread   5:    12364      12:    12365
  Thread   6:    24666      13:    24666
Total: 197129
pmsg [nr queues] [timeout]
Using 8 queues/cpus (16 threads) for 5 seconds.
thread 0: sysvmsg   917504 type 1 bound to 0001h
thread 1: sysvmsg   950273 type 1 bound to 0002h
thread 2: sysvmsg   983042 type 1 bound to 0004h
thread 3: sysvmsg  1015811 type 1 bound to 0008h
thread 4: sysvmsg  1048580 type 1 bound to 0010h
thread 5: sysvmsg  1081349 type 1 bound to 0020h
thread 6: sysvmsg  1114118 type 1 bound to 0040h
thread 7: sysvmsg  1146887 type 1 bound to 0080h
thread 15: sysvmsg  1146887 type 0 bound to 0080h
thread 8: sysvmsg   917504 type 0 bound to 0001h
thread 14: sysvmsg  1114118 type 0 bound to 0040h
thread 13: sysvmsg  1081349 type 0 bound to 0020h
thread 12: sysvmsg  1048580 type 0 bound to 0010h
thread 11: sysvmsg  1015811 type 0 bound to 0008h
thread 10: sysvmsg   983042 type 0 bound to 0004h
thread 9: sysvmsg   950273 type 0 bound to 0002h
Result matrix:
  Thread   0:    11082       8:    11083
  Thread   1:    11461       9:    11461
  Thread   2:    11430      10:    11431
  Thread   3:    11184      11:    11185
  Thread   4:    11373      12:    11374
  Thread   5:    11290      13:    11291
  Thread   6:    11265      14:    11266
  Thread   7:    11324      15:    11325
Total: 180825

--------------080304050300080309060507
Content-Type: text/x-troff-man;
 name="plot.25_rc3_mm1.ref.8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="plot.25_rc3_mm1.ref.8"

1 977300
2 899158
3 1450625
4 1319313
5 456880
6 339103
7 197129
8 180825

--------------080304050300080309060507
Content-Type: text/x-troff-man;
 name="output.25_rc3_mm1.ridr.8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="output.25_rc3_mm1.ridr.8"

pmsg [nr queues] [timeout]
Using 1 queues/cpus (2 threads) for 5 seconds.
thread 0: sysvmsg        0 type 1 bound to 0001h
thread 1: sysvmsg        0 type 0 bound to 0001h
Result matrix:
  Thread   0:   549365       1:   549365
Total: 1098730
pmsg [nr queues] [timeout]
Using 2 queues/cpus (4 threads) for 5 seconds.
thread 0: sysvmsg    32768 type 1 bound to 0001h
thread 1: sysvmsg    65537 type 1 bound to 0002h
thread 3: sysvmsg    65537 type 0 bound to 0002h
thread 2: sysvmsg    32768 type 0 bound to 0001h
Result matrix:
  Thread   0:   245002       2:   245003
  Thread   1:   246618       3:   246619
Total: 983242
pmsg [nr queues] [timeout]
Using 3 queues/cpus (6 threads) for 5 seconds.
thread 0: sysvmsg    98304 type 1 bound to 0001h
thread 1: sysvmsg   131073 type 1 bound to 0002h
thread 2: sysvmsg   163842 type 1 bound to 0004h
thread 5: sysvmsg   163842 type 0 bound to 0004h
thread 4: sysvmsg   131073 type 0 bound to 0002h
thread 3: sysvmsg    98304 type 0 bound to 0001h
Result matrix:
  Thread   0:   231585       3:   231586
  Thread   1:   233256       4:   233256
  Thread   2:   509630       5:   509631
Total: 1948944
pmsg [nr queues] [timeout]
Using 4 queues/cpus (8 threads) for 5 seconds.
thread 0: sysvmsg   196608 type 1 bound to 0001h
thread 1: sysvmsg   229377 type 1 bound to 0002h
thread 2: sysvmsg   262146 type 1 bound to 0004h
thread 3: sysvmsg   294915 type 1 bound to 0008h
thread 5: sysvmsg   229377 type 0 bound to 0002h
thread 6: sysvmsg   262146 type 0 bound to 0004h
thread 7: sysvmsg   294915 type 0 bound to 0008h
thread 4: sysvmsg   196608 type 0 bound to 0001h
Result matrix:
  Thread   0:   233392       4:   233392
  Thread   1:   234485       5:   234486
  Thread   2:   235604       6:   235604
  Thread   3:   235683       7:   235683
Total: 1878329
pmsg [nr queues] [timeout]
Using 5 queues/cpus (10 threads) for 5 seconds.
thread 0: sysvmsg   327680 type 1 bound to 0001h
thread 2: sysvmsg   393218 type 1 bound to 0004h
thread 3: sysvmsg   425987 type 1 bound to 0008h
thread 4: sysvmsg   458756 type 1 bound to 0010h
thread 1: sysvmsg   360449 type 1 bound to 0002h
thread 9: sysvmsg   458756 type 0 bound to 0010h
thread 6: sysvmsg   360449 type 0 bound to 0002h
thread 7: sysvmsg   393218 type 0 bound to 0004h
thread 8: sysvmsg   425987 type 0 bound to 0008h
thread 5: sysvmsg   327680 type 0 bound to 0001h
Result matrix:
  Thread   0:   216094       5:   216095
  Thread   1:   227109       6:   227110
  Thread   2:   222042       7:   222042
  Thread   3:   222708       8:   222708
  Thread   4:   467186       9:   467187
Total: 2710281
pmsg [nr queues] [timeout]
Using 6 queues/cpus (12 threads) for 5 seconds.
thread 0: sysvmsg   491520 type 1 bound to 0001h
thread 1: sysvmsg   524289 type 1 bound to 0002h
thread 2: sysvmsg   557058 type 1 bound to 0004h
thread 3: sysvmsg   589827 type 1 bound to 0008h
thread 4: sysvmsg   622596 type 1 bound to 0010h
thread 5: sysvmsg   655365 type 1 bound to 0020h
thread 6: sysvmsg   491520 type 0 bound to 0001h
thread 11: sysvmsg   655365 type 0 bound to 0020h
thread 8: sysvmsg   557058 type 0 bound to 0004h
thread 10: sysvmsg   622596 type 0 bound to 0010h
thread 9: sysvmsg   589827 type 0 bound to 0008h
thread 7: sysvmsg   524289 type 0 bound to 0002h
Result matrix:
  Thread   0:   224027       6:   224028
  Thread   1:   225394       7:   225394
  Thread   2:   223545       8:   223545
  Thread   3:   223599       9:   223599
  Thread   4:   224632      10:   224633
  Thread   5:   224511      11:   224512
Total: 2691419
pmsg [nr queues] [timeout]
Using 7 queues/cpus (14 threads) for 5 seconds.
thread 0: sysvmsg   688128 type 1 bound to 0001h
thread 1: sysvmsg   720897 type 1 bound to 0002h
thread 2: sysvmsg   753666 type 1 bound to 0004h
thread 3: sysvmsg   786435 type 1 bound to 0008h
thread 4: sysvmsg   819204 type 1 bound to 0010h
thread 5: sysvmsg   851973 type 1 bound to 0020h
thread 6: sysvmsg   884742 type 1 bound to 0040h
thread 13: sysvmsg   884742 type 0 bound to 0040h
thread 8: sysvmsg   720897 type 0 bound to 0002h
thread 9: sysvmsg   753666 type 0 bound to 0004h
thread 10: sysvmsg   786435 type 0 bound to 0008h
thread 11: sysvmsg   819204 type 0 bound to 0010h
thread 7: sysvmsg   688128 type 0 bound to 0001h
thread 12: sysvmsg   851973 type 0 bound to 0020h
Result matrix:
  Thread   0:   188264       7:   188264
  Thread   1:   190677       8:   190677
  Thread   2:   188850       9:   188851
  Thread   3:   188925      10:   188926
  Thread   4:   190333      11:   190334
  Thread   5:   189235      12:   189235
  Thread   6:   386862      13:   386863
Total: 3046296
pmsg [nr queues] [timeout]
Using 8 queues/cpus (16 threads) for 5 seconds.
thread 0: sysvmsg   917504 type 1 bound to 0001h
thread 1: sysvmsg   950273 type 1 bound to 0002h
thread 2: sysvmsg   983042 type 1 bound to 0004h
thread 3: sysvmsg  1015811 type 1 bound to 0008h
thread 4: sysvmsg  1048580 type 1 bound to 0010h
thread 5: sysvmsg  1081349 type 1 bound to 0020h
thread 6: sysvmsg  1114118 type 1 bound to 0040h
thread 7: sysvmsg  1146887 type 1 bound to 0080h
thread 8: sysvmsg   917504 type 0 bound to 0001h
thread 10: sysvmsg   983042 type 0 bound to 0004h
thread 11: sysvmsg  1015811 type 0 bound to 0008h
thread 12: sysvmsg  1048580 type 0 bound to 0010h
thread 13: sysvmsg  1081349 type 0 bound to 0020h
thread 9: sysvmsg   950273 type 0 bound to 0002h
thread 15: sysvmsg  1146887 type 0 bound to 0080h
thread 14: sysvmsg  1114118 type 0 bound to 0040h
Result matrix:
  Thread   0:   187613       8:   187614
  Thread   1:   190488       9:   190489
  Thread   2:   190112      10:   190113
  Thread   3:   190374      11:   190375
  Thread   4:   190658      12:   190658
  Thread   5:   190508      13:   190508
  Thread   6:   189222      14:   189223
  Thread   7:   190272      15:   190272
Total: 3038499

--------------080304050300080309060507
Content-Type: text/x-troff-man;
 name="plot.25_rc3_mm1.ridr.8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="plot.25_rc3_mm1.ridr.8"

1 1098730
2 983242
3 1948944
4 1878329
5 2710281
6 2691419
7 3046296
8 3038499

--------------080304050300080309060507--
