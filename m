Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYFMWcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYFMWcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 18:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbYFMWbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 18:31:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:38320 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbYFMWbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 18:31:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=irsbCoqb+24x5hY3Rw9fplhDa2YIPR4UXkoOYQ2+xobE+IO/2TFpoJA6dnN1IPAZ1j
         5D4DuPVQc4vLJNnV5MfaCzpdhcXK1tGYNO0ARzaVRwhZVaGzwhffGWGUaTai5mz4Px7U
         S8TEClACBUGjY9uFtg9wX+GCi4H2ekLsBiJMg=
Message-ID: <7c86c4470806131531n4b24bc4dmc22d4b2277e75f24@mail.gmail.com>
Date: Sat, 14 Jun 2008 00:31:43 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Greg KH" <greg@kroah.com>
Subject: Re: [patch 12/21] perfmon2 minimal: sysfs interface
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080613035339.GE17872@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <484daff1.1358560a.0808.0267@mx.google.com>
	 <20080611144955.GA20145@kroah.com>
	 <7c86c4470806110800w465f1c91k7e8f0bb8fba18ca3@mail.gmail.com>
	 <7c86c4470806120554w38a11307qa34511cf4f8b4aba@mail.gmail.com>
	 <20080613035339.GE17872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,



On Fri, Jun 13, 2008 at 5:53 AM, Greg KH <greg@kroah.com> wrote:
> On Thu, Jun 12, 2008 at 02:54:15PM +0200, stephane eranian wrote:
>>
>> In any case, let me know if there are still things that must be
>> changed/simplified in my file.
>
> This looks much better.  I wonder if you could use the "default" kobject
> attributes, which might allow you to remove some of your show/store
> wrappers, but in general, it's much better than before.
>
Well, I wondered about that myself, but I think I am missing one piece.
The difference between some of the show/store functions and others
is that if you look closely, you see that some make reference to global
structures, e.g., pfm_controls, or call out to routines in others modules.
For those, I have switched to the default attribute. But the other show/store
functions need to access the particular object where the kobj is embedded.
And for that, it seems you need to glue function:

#define to_pmu(n) container_of(n, struct pfm_pmu_config, kobj)

static ssize_t pfm_pmu_attr_show(struct kobject *kobj,
                struct attribute *attr, char *buf)
{
        struct pfm_pmu_config *pmu = to_pmu(kobj);
        struct pfm_attribute *attribute = to_attr(attr);
        return attribute->show ? attribute->show(pmu, attribute, buf) : -EIO;
}

which basically calls the container_of() routine..

Yet, I get the feeling that is the show routein gets the same kobj,
then I could as well do the
to_pmu() there. And the attr (use the the strcmp()) would be the default.

If you tell me this is the way to go, I will certainly be happy to
make the change and remove even
more code!


Thanks.
