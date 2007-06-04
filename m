Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbXFDUvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbXFDUvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXFDUvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:51:12 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42701 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbXFDUvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:51:11 -0400
Date: Mon, 4 Jun 2007 15:51:06 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, akpm@linux-foundation.org, dev@sw.ru,
       xemul@sw.ru, vatsa@in.ibm.com, ebiederm@xmission.com,
       haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       pj@sgi.com, cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Message-ID: <20070604205106.GA31530@sergelap.austin.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com> <20070604191412.GA901@sergelap.austin.ibm.com> <6599ad830706041332o718acb60ve0b5e38c2ca82c62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830706041332o718acb60ve0b5e38c2ca82c62@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On 6/4/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >
> >2. I can't delete containers because of the files they contain, and
> >am not allowed to delete those files by hand.
> >
> 
> You should be able to delete a container with rmdir as long as it's
> not in use - its control files will get cleaned up automatically.
> 
> If you're getting an EBUSY error that means that either there are
> still tasks running in the container (look in the "tasks" file) or
> else there's a reference counting bug somewhere.
> 
> Can you post an example to reproduce the problem?

here is an excerpt:

[root@linuz11 root]# mount -t container -ocpuset cpuset /containers/
[root@linuz11 root]# ls /containers/
cpu_exclusive   memory_pressure          mems               tasks
cpus            memory_pressure_enabled  notify_on_release
mem_exclusive   memory_spread_page       releasable
memory_migrate  memory_spread_slab       release_agent
[root@linuz11 root]# mkdir /containers/1
[root@linuz11 root]# echo 0 > /containers/1/mems
[root@linuz11 root]# echo 0 > /containers/1/cpus
[root@linuz11 root]# sh
sh-2.05b# echo $$ > /containers/1/tasks
sh-2.05b# cat /containers/1/tasks 
4325
4326
sh-2.05b# exit
[root@linuz11 root]# ls /containers/1/tasks 
/containers/1/tasks
[root@linuz11 root]# rm -rf /containers/1 
rm: cannot remove `/containers/1/memory_spread_slab': Operation not
permitted
rm: cannot remove `/containers/1/memory_spread_page': Operation not
permitted
rm: cannot remove `/containers/1/memory_pressure': Operation not
permitted
rm: cannot remove `/containers/1/memory_migrate': Operation not
permitted
rm: cannot remove `/containers/1/mem_exclusive': Operation not permitted
rm: cannot remove `/containers/1/cpu_exclusive': Operation not permitted
rm: cannot remove `/containers/1/mems': Operation not permitted
rm: cannot remove `/containers/1/cpus': Operation not permitted
rm: cannot remove `/containers/1/releasable': Operation not permitted
rm: cannot remove `/containers/1/notify_on_release': Operation not
permitted
rm: cannot remove `/containers/1/tasks': Operation not permitted

Ah, I see the second time I typed 'ls /containers/1/tasks' instead of
cat.  When I then used cat, the file was empty, and I got an oops just
like Pavel reported.  I bet if I solve the problem he reported, then I
solve my problem  :)

thanks,
-serge
