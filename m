Return-Path: <linux-kernel-owner+w=401wt.eu-S1032182AbXFHWEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032182AbXFHWEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030236AbXFHWEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:04:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:37217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967990AbXFHWEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:04:06 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Date: Sat, 9 Jun 2007 00:03:57 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de> <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3929
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200706090003.57722.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 June 2007 15:26, Stephen Smalley wrote:
> On Mon, 2007-06-04 at 23:03 +0200, Andreas Gruenbacher wrote:
> > [...] SELinux turns pathnames into labels when it
> > initially labels all files (when a policy is rolled out), whereas
> > AppArmor computes the "label" of each file when a file is opened. The two
> > models start to diverge as soon as files are renamed: in SELinux, labels
> > stick with the files. In AppArmor, "labels" stick with the names.
>
> I'd argue a bit with that characterization, given that:
> - in the case of SELinux, the pathname is never used as a basis for
> decisions by the kernel,

Indeed, the kernel component of SELinux only uses file labels for making file 
access decisions and not pathnames. But those labels were initially created  
by a trusted process (e.g. restorecon) based on pathnames, and this initial 
labeling is an essential part of the SELinux model. So in a sense, 
disregarding creation and relabeling of files, one could argue that SELinux 
makes decisions based on the pathnames that files had when they were labeled.

In SELinux, labels are the only thing that distinguishes between files. So if 
at one point you find that you need to distinguish between files that share a 
label, you have to split the label and reclassify the files in addition to 
adjusting the policy. Again, the usual approach for reclassifying files will 
probably be pathname based.

In contrast, AppArmor does not use labels, and the pathnames at the time of 
access distinguish between files. Since files do not have labels, no 
relabeling is necessary in order to change policy.

> - under AA, each file may have an arbitrary set of "labels" or
> "policies" applied to it depending on what programs are accessing it and
> what names are being used to reference it - there is no system view of
> the subjects and objects and thus no way to identify the overall system
> policy for a given file.

Look at it this way: under SELinux, the set of files that share a label forms 
an equivalence class -- they are all treated identically by the system's 
security policy. The rules in AppArmor profiles also define equivalence 
classes in the sense that they partition the filesystem namespace into sets 
of files that are treated identically, but this classification is not 
explicit -- the entire rule base contributes to the classification. This 
doesn't mean that there is not a global policy, just that the policy is 
modeled differently. The equivalence classes are not directly obvious from 
the AA profiles.

Contrast this with SEEdit, which compiles AA-style rules into labels (and thus 
equivalence classes). The resulting SELinux policy is a static snapshot that 
cannot easily accommodate rule base changes, is more limited with respect to 
new files (which would likely be fixable), and behaves differently in complex 
ways with file renames. What's more, most likely the compiled policy will be 
anywhere from very hard to impossible to analyze, so you pretty much lose on 
all ends.

I'm not saying that labels are crap and that SELinux is wrong. In fact, labels 
are useful for some things like model verification and information flow 
analysis. What I'm saying is that AppArmor and SELinux implement different 
models, and those models cannot be modeled in terms of each other.

Note that I'm not embarking on implementation aspects here at all, only on the 
fundamental model differences.

> - names are far less tranquil than labels.

If I'm getting things right, a tranquil system with respect to labels would be 
one that does not permit re-labeling, while a tranquil system with respect to 
path names would be one that does not permit renaming. Both approaches would 
buy greater analyzability with reduced usability, and both seem unrealistic 
to me. SELinux and AppArmor evidently have different goals, and tranquility 
is more important to SELinux.

AppArmor is meant to be relatively easy to understand, manage, and customize, 
and introducing a labels layer wouldn't help these goals. SELinux is 
applicable in areas where AppArmor is not (e.g., MLS), but this comes at a 
cost. For me the question is not SELinux or AppArmor, but if AppArmor's 
security model is a good solution in common scenarios. In my opinion, 
AppArmor is a better answer than SELinux in a number of scenarios. This gives 
it value, nonwithstanding the fact that SELinux can be taken further.

Thanks,
Andreas
