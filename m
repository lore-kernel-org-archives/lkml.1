Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbZCUHj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbZCUHj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 03:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbZCUHjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 03:39:44 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52056 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbZCUHjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 03:39:43 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, <netdev@vger.kernel.org>
References: <49B91A7E.76E4.0078.0@novell.com>
	<tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org>
	<1236934491.5188.209.camel@laptop> <49BA33BE.76E4.0078.0@novell.com>
	<1236937423.22914.3698.camel@twins> <20090313103828.GB31094@elte.hu>
	<m1d4cd9n4k.fsf@fess.ebiederm.org> <20090320085205.GB16021@elte.hu>
	<m14oxo8qis.fsf@fess.ebiederm.org> <20090320182404.GA31629@elte.hu>
	<1237575134.4667.5.camel@laptop> <1237577688.4667.68.camel@laptop>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 21 Mar 2009 00:39:28 -0700
In-Reply-To: <1237577688.4667.68.camel@laptop> (Peter Zijlstra's message of "Fri\, 20 Mar 2009 20\:34\:48 +0100")
Message-ID: <m1iqm3xr2n.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, netdev@vger.kernel.org, adobriyan@gmail.com, peterz@infradead.org, ego@in.ibm.com, linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, jbeulich@novell.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMNoVowels Alpha-numberic number with no vowels
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 0/2] sysctl: lockdep support.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The problem:  There is a class of deadlocks that we currently
have in the kernel that lockdep does not recognize. 

In particular with the network stack we can have:

rtnl_lock();                         use_table();
unregister_netdevice();              rtnl_lock();
unregister_sysctl_table();           ....
wait_for_completion();               rtnl_lock();
....                                 unuse_table()
rtnl_unlock();                       complete();



Where we never make it to the lines labled ....

My patch following patches treats the sysctl use count as a read/writer
lock for purposes of lockdep.

The code works but I'm not certain I have plugged into lockdep quite
correctly.

Eric

