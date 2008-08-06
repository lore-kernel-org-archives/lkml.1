Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbYHFBBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbYHFBBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 21:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYHFBBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 21:01:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33368 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYHFBBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 21:01:23 -0400
Date: Wed, 6 Aug 2008 10:05:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Containers <containers@lists.osdl.org>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       balbir@linux.vnet.ibm.com
Subject: Re: [Libcg-devel] Control groups and Resource Management notes
 (part II)
Message-Id: <20080806100500.19f08444.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080805133007.GC15193@redhat.com>
References: <489315B2.2080506@linux.vnet.ibm.com>
	<4893B415.9070906@linux.vnet.ibm.com>
	<20080805160709.A88B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080805133007.GC15193@redhat.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008 09:30:07 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Tue, Aug 05, 2008 at 04:45:30PM +0900, KOSAKI Motohiro wrote:
> > > Control group library
> > > =====================
> > > Dhaval and Balbir introduced libcgroups and the purpose of the library and the
> > > goals. Balbir described on paper what the current design looks like, it consists of
> > > 
> > > 	1. API
> > > 	2. Test framework
> > > 	3. A configuration subsystem
> > > 
> > > Dhaval discussed configuration syntax of XML versus home made. The issue of
> > > classification of tasks was brought up. The reason that we want to classify
> > > tasks is that we want them to move at fork/exec time to the correct cgroup so that
> > 
> > I don't recommend XML, because XML is tree based syntax but we want more fulexible
> > classification. then I guess XML reduce human readability.
> > 
> > 
> > > 1. They don't consume resources in the parents group
> > > 2. The movement is automatic
> > > 
> > > It was generally agreed upon that the classification should take place in user
> > > space. Eric and others suggested having a wrapper to start the application in
> > > the correct cgroup (wrapper around fork/exec). Dave suggested that one might
> > > even go the extent of hacking, such that a process is ptraced after fork/exec,
> > > moved to the correct group and resumed. Using SELinux contexts was also recommended.
> > > 
> > > Vivek brought up using PAM plugins to do classifications, this suggestion was
> > > nicely received. The decision was to do classification in user space and then
> > > think of kernel space if it cannot be done in user space. Denis suggested that
> > > classification is useful. In OpenVZ they classify all apache children to a
> > > different group. Balbir asked Denis to post their classification infrastructure
> > > as RFC.
> > 
> > I'm not sure about this issue.
> > but I like PAM approach.
> > 
> 
> Thanks balbir for nice summary.
> 
Thanks, too.

> Well, it was Rik Van Riel's idea to use PAM plugins so that processes
> are put into right user cgroups upon login.
> 
> Is pam based classification alone is sufficient? I noticed couple of
> instances which will avoid pam. For example.
> 
> - If one starts apache "service httpd start", then httpd threads change
>   their uid/gid to "apache/apache". But these threads will continue to
>   run in the cgroup belonging to root and will not go into apache cgroup.
> 
> - apache also offers "suexec" tool which execs a CGI script under a 
>   different user than the user who has launched web server. I quickly
>   grepped for source code of suexec and it does not seem to be using
>   pam. That means CGI scripts running under some other user name will
>   continue to run in cgroup where apache is running.
> 
> I am not sure how many more such corner cases are there. These cases can
> either be covered by modification of application or using some kind of
> wrapper around application or by writing classification daemon.
> 
> Do we really need classification daemon to cover such cases or wrapper
> approach is sufficient? I remember somebody in minisummit was mentioning
> that it should work without any apache modifications.
> 

We can go ahead step by step. I think PAM support is the first step.
The daemon is the second.

1. PAM
2. A daemon for task placement (via netlink ?)

I think developping "a daemon for task placement" is important.
but cannot be perfect solution for any situations.

The third step is

3. Modify applications (in newer version of them.)

"should work without any apache modifications" is (maybe) necessary. But for 
perfect control, it's not enough. We should support a method to modify
applications easily in library. 

I think develpment cost for "2" is bigger than "1" and "3". If "2" is hard,
starting from "1" and support funcs for "3" is a choice.
If support for "3" is ready, someone may start implementation of "2" in easier
way.

Thanks,
-Kame

