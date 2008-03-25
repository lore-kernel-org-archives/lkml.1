Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbYCYWca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbYCYWca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbYCYWcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:32:20 -0400
Received: from mx1.suse.de ([195.135.220.2]:56209 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbYCYWcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:32:19 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Tetsuo Handa" <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Wed, 26 Mar 2008 09:32:08 +1100 (EST)
Message-ID: <57096.192.168.1.70.1206484328.squirrel@neil.brown.name>
In-Reply-To: <200803252045.CGB04105.HLSQFOJMtOFVOF@I-love.SAKURA.ne.jp>
References: <20080321155451.GU10722@ZenIV.linux.org.uk>
    <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu>
    <20080321163520.GV10722@ZenIV.linux.org.uk>
    <E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu>
    <18408.26863.617591.836548@notabene.brown>
    <200803252045.CGB04105.HLSQFOJMtOFVOF@I-love.SAKURA.ne.jp>
Subject: Re: r-o bind in nfsd
Cc: miklos@szeredi.hu, viro@zeniv.linux.org.uk, haveblue@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org,
       linux-security-module@vger.kernel.org, jmorris@namei.org
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, March 25, 2008 10:45 pm, Tetsuo Handa wrote:
> Hello.
>
>> Maybe some enhancement to the 'intent' structure with a similar
>> effect could be done instead.
>>
>> Then you could, presumably, put a security hook somewhere in
>> link_path_walk for those modules (like AppArmor) which want to do
>> checks based on the namespace.
>
> I think link_path_walk() is not a good place to insert new LSM hooks
> for pathname based access control (AppArmor and TOMOYO) purpose because
>
>   (1) The kernel don't know what operation (open/create/truncate etc.)
> will be
>       done at the moment of link_path_walk().

Though the 'indent' data structure could be used to carry this information.

>
>   (2) Not all operations call link_path_walk() before these operations
>       are done. For example, ftruncate() doesn't call link_path_walk().

But do you want to impose path-name based controls to ftruncate?
Surely once you have a file open for write (not O_APPEND), then no
other permission is required to truncate the file, is it?
If it is, then maybe the 'struct file' should be tagged at open time
to say whether 'truncate' is allowed.

>
>   (3) The rename() and link() operations handle two pathnames.
>       But, it is not possible to know both pathnames at the moment of
>       link_path_walk().

Not an insolvable problem.
One could imagine an implementation where a TYPE_RENAME_FROM security
check produced a cookie that was consumed by a TYPE_RENAME_TO security
check.  The cookie could then be used by the security module to
make any connection between the two names that might be appropriate.

>
> I think we need to introduce new LSM hooks outside link_path_walk().
> http://kerneltrap.org/mailarchive/linux-fsdevel/2008/2/17/882024
>
<rant>
I suspect we would be much better off removing all the security hooks.
Security done at that level seems to be way too complex such that most
people don't really understand it.  And people who don't understand
security don't use it.
We'd be much better off getting rid of the whole "micro-manage security"
concept and provide isolation via some sort of high level container
approach.
</rant>

NeilBrown

