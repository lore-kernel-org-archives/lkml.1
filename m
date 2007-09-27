Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbXI0HMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbXI0HMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 03:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbXI0HMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 03:12:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:63793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbXI0HM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 03:12:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Landley <rob@landley.net>
Subject: Re: [Announce] Linux-tiny project revival
Date: Thu, 27 Sep 2007 09:00:36 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net>
In-Reply-To: <200709201538.43093.rob@landley.net>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?iso-8859-1?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?iso-8859-1?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ?=
 =?iso-8859-1?q?=0A=098MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?iso-8859-1?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?iso-8859-1?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
Cc: linux-tiny@selenic.com, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709270900.36602.arnd@arndb.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX194Qb6AJeBL++OEhgvmXju9jfRYttyXLfKj5QV
 Gn3UT2PAnh6sEiroXp6eZjf95xT1x98Fe5JHz1V3H/x3R7jP4W
 M3LoVG31uwTaSXncbH0MA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007, you wrote:
> So instead of:
>   printk(KERN_NOTICE "Fruit=%d\n", banana);
> It would now be:
>   printk(KERN_NOTICE, "Fruit=%d\n", banana);
> 
> Change the header from:
>   #define KERN_NOTICE "<5>"
> to:
>   #define KERN_NOTICE 5
> 
> Then you can change the printk guts to do something vaguely like (untested):
> #define printk(arg1, arg2, ...) actual_printk("<" #arg1 ">" arg2, __VA_ARGS__)
> 
> And so far no behavior has changed.  But now the _fun_ part is, you can add a 
> config symbol for "what is the minimum loglevel I care about?"  Set that as a 
> number from 0-9.  And then you can define the printk to do:
> 
> #define printk(level, str, ...) \
>   do { \
>     if (level < CONFIG_PRINTK_DOICARE) \
>       actual_printk("<" #level ">" str, __VA_ARGS__); \
>   } while(0);
> 

Assuming that we want to go down that road, I think you can do better with
more evil macro magic, by using something along the lines of

#define KERN_NOTICE "<5>",

#define PRINTK_CONTINUED "",

 #define printk(level, str, ...) \
   do { \
     if (sizeof(level) == 1) /* continued printk */\
	actual_printk(str, __VA_ARGS__); \
     else if ((level[1] - '0') < CONFIG_PRINTK_DOICARE) \
       actual_printk(level str, __VA_ARGS__); \
   } while(0);

Then you don't have to change every single printk in the kernel, but
only those that don't currently come with a log level. More importantly,
you can do the conversion without a flag day, by spreading (an empty)
PRINTK_CONTINUED in places that do need a printk without a log level.

	Arnd <><
