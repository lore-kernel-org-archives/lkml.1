Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZBTEhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZBTEhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 23:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZBTEgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 23:36:50 -0500
Received: from smtp106.prem.mail.sp1.yahoo.com ([98.136.44.61]:20170 "HELO
	smtp106.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751379AbZBTEgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 23:36:49 -0500
X-YMail-OSG: 1KZ8.HkVM1kTZwrQ1PTX_yU3hEkhQsKLhm.n4xvL2hH5RizqSsllnuK1sHZpV__NKZGBf5yk9XRWIIl8p3HCw0BsIIeV5QyWUNfj0AI7uMdzqkVTrbnuHCNb86MgSSzGDEFxr1jiPb6b.mPnI2sruxXrQlblDMtRvE9Y1WiyGZfdpVI0VyJ2PVSvah._BpqnG3B.97NxBDMr2zutWwlRK1zFg8bqsi50WsqF4ngncgB4iEip.xnNtVIfKhbS1fCInkaPvNz4earlclumi4Iwsswq
X-Yahoo-Newman-Property: ymail-3
Message-ID: <499E3353.7020305@schaufler-ca.com>
Date: Thu, 19 Feb 2009 20:36:35 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: etienne <etienne.basset@numericable.fr>
CC: Paul Moore <paul.moore@hp.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       LSM <linux-security-module@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] SMACK netfilter smacklabel socket match
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <200902171852.21061.paul.moore@hp.com> <499BB76C.1030109@numericable.fr> <200902181005.24952.paul.moore@hp.com> <499C40C1.20106@schaufler-ca.com> <499C62E4.1030600@numericable.fr>
In-Reply-To: <499C62E4.1030600@numericable.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

etienne wrote:
> ...
>> Etienne, thank you very much for the work you've done so far. Paul,
>> thank you for your recommendations.
>>     
>
> well, I'll try to explain my use case for SMACK, could you please tell me if this makes sense and if it is doable and sane with SMACK :
>
> I have single-user computer that, for simplicity sake, do only web browsing with firefox; 
> the attack vector i'm concerned with is malicious web pages, that could execute malicious code on my computer or worse erase some of my data; 
>
> so i express the following security policy in a tool-agnostic way :
> 1. firefox can access internet
>   

In Smack terms then you want the process label of your browser
process to have access to hosts on the internet in general. The
easy way to do this is for it to run with the ambient label
(cat /smack/ambient to see it) which will be the floor label "_"
unless you change it. Note that your browser will need to talk
to the X11 server as well, so processes with the label of the
browser will need write access to processes with the label of the
X11 server, and visa versa.

> 2. firefox can read/write it's configuration directory in my $HOME
>   

The label of the process will have to match the label of that
directory for this to work.

> 3. firefox can read/write to a download directory
>   

Again, the label will have to match.

> 4. firefox can execute kpdf, okular, vlc etc...
>   

All these files will have the floor label "_" by design, so this
is easy,
> 5. firefox can read system files
>   

Again, system files will have the floor label, so this is easy.

> 6. firefox can write to temporary folder
>   

Do you need to use /tmp, or does firefox respect $TMPDIR?
You can set the label of /tmp to the star "*" label if worse
comes to worst.

> pretty simple. So I expect the 'tool' to express this policy in very few line; (i had a look at selinux/refpolicy, and I'm ashamed I was too lazy to test/understand further).

Don't be ashamed. I wrote Smack because I was too lazy to figure
out SELinux policy.

>  And if possible a mainline tool would be a big bonus.
>
> So I decided to give  smack  a try, and here are my notes/interrogations :
>
> rule 1. if i understand correctly, I have to load the following smack rule  
> "firefox _ rwx" 
> well, as '_' is the default objectlabel for all system files, it means that firefox will have smack 'w' access on system. 
>
> So first issue : is it possible to express network access in another way?
> Or maybe I have to relabel  /bin/, /sbin etc with a custom system label ?
>   

If you want firefox to talk on the internet, and have
no other processes talk on the internet including the X11 server,
you need to run firefox with a different label from everything
else. This will make it difficult to talk to the X11 server.

> rule 2-6 : easy to implement with smack, i label my $HOME with some label and download/cfg dir with other labels
> Firefox won't have rw access to my $HOME hehe
>
> Second issue : what is the simplest way to start firefox with the firefox label?
> I used the following hack : write a small program (i used cap_mac_admin, could have been suid) that :
> a) set /proc/self/attr/current
> b) drop capabilities
> c) start firefox
> Is there a cleanest way, can a process be started with its objectlabel?
>
>   

I have a newsmack program, but all that it does is what your "hack"
does.

> Third issue : there seems to be  no way to log/audit access violations, have you plans to implement that?
>   

Hmm. Audit should be working.

> best regards,
> Etienne
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

