Return-Path: <linux-kernel-owner+w=401wt.eu-S1765864AbYCDS1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765864AbYCDS1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759845AbYCDS1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:27:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:42360 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761469AbYCDS1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:27:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=ldWxqjBz1ZL0UXJP/SLZ/4LETaq0DHzyl/eadjGp0Iu81EgU+QiODc1RvueZqA+eicODPjiRbV2SSg5Fhocv+lH/TmM0Iq4G4/hI19ZiUulEQwlqzOgLoUmC+MdYZ0aor5Fy39tduRV3q2TQIkHieVFqwQQO3CvDAFPcY8QzW9k=
Date: Tue, 4 Mar 2008 20:24:03 +0200
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH BUGFIX -rc3] Smack: Don't register smackfs if we're not
	loaded
Message-ID: <20080304182403.GA9792@ubuntu>
References: <20080304131055.GA25577@ubuntu> <alpine.LFD.1.00.0803040920080.12253@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803040920080.12253@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

[Adding SELinux devs to CC list, please follow to the SELinux point.]

On Tue, Mar 04, 2008 at 09:21:19AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 4 Mar 2008, Ahmed S. Darwish wrote:
> > 
> > Smackfs initialization without an enabled Smack leads to
> > an early Oops that renders the system unusable.
> 
> I really think this is bogus. Global enables like this are just wrong, and 
> a sign that something else bad is going on.
> 
> What is the oops? Why does it happen?
> 

The problem occurs when Smack is built-in the kernel but not chosen
to register itself on boot. Smack was not chosen on boot cause either
security=AnotherLSM or security=NonExistentLSM.

In all cases, init_smk_fs() ,which registers smackfs, got called
cause it's an __initcall(init_smack_fs). 
This include the cases where smack __was not__ chosen on boot.

Making smackfs mountable when Smack is not registered leads to:

1- an Oops by dereferncing the NULL security pointer: current->security (*)

2- Smackfs code got executed though naturally all the code assumes
   that smack is already registered with the security system leading
   to several problems.

3- The bogus idea of having a subsystem interface available when the
   subsystem itself is not available!

So the global is used in init_smk_fs to not register smackfs if
Smack wasn't enabled on boot.

---- SELinux:

I think the SELinux folks faced the same problem too. In my first 
local iteration of the security= parameter patch, I forgot to set 
`selinux_disable = 1' if SELinux wasn't chosen on boot.

This led to dozen of SELinux Udev events and also led to selinuxfs 
being available even though SELinux hooks _weren't_ registered.

Regards,

(*) 
    Could not save the oops cause it occured too early, but
    it was like this:

    __init_call
    init_smk_fs(void)
    smk_unlbl_ambient(NULL)
    /* 
     * Here: current->security = NULL, cause SMACK initial setup
     * was not executed.
     */
    smack_to_secid(current->security) 
    strncmp(.., current->security, ..) 
    
-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

