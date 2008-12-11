Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbYLKAKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbYLKAKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYLKAKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:10:07 -0500
Received: from smtp109.prem.mail.sp1.yahoo.com ([98.136.44.54]:36780 "HELO
	smtp109.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752571AbYLKAKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:10:06 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Dec 2008 19:10:06 EST
X-YMail-OSG: NiaJZRgVM1nlWI4IZXaTY9JlgDoOQ.3wsqlBhTkTKFVNM736Z7SO_guBuGXOB7CN9iR6QSpBHzVSCYlZ8OBLonciA22ZITdV57FvUGTUJOmvU2q7yOZC6_mW56O61b4393GJyepXehioQi0n3NZEtoK74RngVknCSeXbyAUPpK5Qk0O7jXIaeHUG_c8YCRK6ohI29QbDGhCrVcd.J1GeMG0IDf7gSUfq1.cyci2RyXgpWG1yxRSazw--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <494058BF.9010801@schaufler-ca.com>
Date: Wed, 10 Dec 2008 16:03:11 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Tilman Baumann <tilman.baumann@collax.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com> <48E19D01.9050809@schaufler-ca.com> <48E35F36.4030203@collax.com> <48E3957A.7040201@schaufler-ca.com> <48E3AB97.8020305@collax.com> <48E3BFDE.7010300@schaufler-ca.com> <48EA0B30.6080907@collax.com> <48EACC91.8040008@schaufler-ca.com> <48F8C3EC.1030607@collax.com> <48F8D122.3010105@schaufler-ca.com> <48FC744F.6030507@collax.com> <48FE9FCB.6070202@schaufler-ca.com> <4909DB7A.7040209@collax.com>
In-Reply-To: <4909DB7A.7040209@collax.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Baumann wrote:
>
>
> Casey Schaufler wrote:
>> Tilman Baumann wrote:
>>>> If you're up to trying out something that you know is going to get
>>>> rewhacked before it goes in anywhere let me know.
>>>
>>> Sure. I will be happy to use that.
>>> Just tell me where to find it and how to use it and what I should 
>>> look out for.
>>>
>>
>> You'll need to start out with Paul Moore's testing tree:
>>
>> % git clone git://git.infradead.org/users/pcmoore/lblnet-2.6_testing
>>
>> Apply the attached patch (attachments are discouraged for review 
>> purposes,
>> but this is handier for this purpose) and compile.
>>
>> This is NOT production code. Again, we're hashing out the netlabel 
>> api and
>> we know that they are going to change. This is demo only. The amount of
>> testing it's gotten is really small.
>>
>> I have created a new system label "@", pronounced "at" and referred 
>> to as
>> the internet label. Processes cannot be assigned the internet label. A
>> subject with the internet label (as identified by a packet thus labeled)
>> can write to any object and any subject can write to an object thus 
>> labeled,
>> thereby explicitly blowing a hole in the Access Control Policy.
>>
>> Have fun, let me know what you hit next.
>
> Sorry for the long delay. I was annoyingly occupied with other things.

My turn!

>
> I just tried this out. But one thing makes me wonder if I had 
> understood what it should do.
> The syntax for /smack/slhost is IP[/MASK] LABEL.
> When I give one host (in my case generously 0.0.0.0/0 *g*) a label 
> what is the significance of the @ label?
> First I used the _ label here which had the effect that everything 
> seems  to work but labeled processes still produced labeled packet 
> which got slaughtered in different ways and degrees over the internet.
> If I gave my slhost the @ label my machine was offline and did not 
> even get pings out locally.
>
> I get the feeling I did not understand the concept yet.
> Sorry but if you don't mind giving me a hint...
>

OK, Paul and I knocked our heads together until we got the behavior and
interfaces ironed out if not to our mutual satisfaction at least to a
workable level. Paul's next tree:

    % git clone git://git.infradead.org/users/pcmoore/lblnet-2.6_next

has the current version. There are a couple interesting things going on.

    - /smack/nltype is gone. It never lived up to its promise and is no
      longer required to determine the labeling scheme.
    - /smack/netlabel replaces the earlier /smack/slhost because it better
      describes what it gets used for.
    - The "@" label (pronounced "web") has been added to the list of special
      labels. A packet with the web label will get delivered anywhere. A
      network address specified to have the web label can be written to by
      any process. Processes can not have the web label.
    - An incoming packet from an address in the netlabel list that has a 
CIPSO
      label attached will still use the label from the CIPSO packet.
    - An unlabeled packet coming from an address in the netlabel list 
will be
      given the label associated with that address.
    - A process that wants to send a packet to an address on the list needs
      write access to the label associated with that address. The packet 
will
      be sent unlabeled if it is allowed.

So, if I want my old Sony to be treated as a single-label host with the
label "Pop" I can say:

    # echo 192.168.1.102/32 Pop > /smack/netlabel

If I want the secondary network for my development machines to be 
single-label

    # echo 192.168.2.0/24 Snap > /smack/netlabel

And if I want everyone to be able to communicate with my spam server

    # echo 207.69.188.187 '@' > /smack/netlabel


