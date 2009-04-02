Return-Path: <linux-kernel-owner+w=401wt.eu-S1764893AbZDBSel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764893AbZDBSel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758240AbZDBSe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:34:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36579 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742AbZDBSeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:34:24 -0400
Date: Thu, 2 Apr 2009 20:34:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] perf_counter: add more context information
Message-ID: <20090402183417.GA843@elte.hu>
References: <20090402091158.291810516@chello.nl> <20090402091319.493101305@chello.nl> <20090402113643.GF10828@elte.hu> <1238672889.8530.5908.camel@twins> <20090402181849.GD6340@elte.hu> <1238696998.5133.44.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238696998.5133.44.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2009-04-02 at 20:18 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Thu, 2009-04-02 at 13:36 +0200, Ingo Molnar wrote:
> > > 
> > > > > -#define MAX_STACK_DEPTH		255
> > > > > +#define MAX_STACK_DEPTH		254
> > > > >  
> > > > >  struct perf_callchain_entry {
> > > > > -	u64	nr;
> > > > > +	u32	nr, hv, kernel, user;
> > > > >  	u64	ip[MAX_STACK_DEPTH];
> > > > >  };
> > > 
> > > Oh, and Paul suggested using u16s right after I send it out. So 
> > > I'll either send an update or send a incremental in case you 
> > > already applied it.
> > 
> > yes, that's probably a good idea. Although u8 might be even better - 
> > do we ever want to do more than 256 deep stack vectors? Even those 
> > would take quite some time to construct and pass down.
> 
> We'd have to pad it with 4 more bytes to remain u64 aligned,

ok, indeed.

> [...] also, why restrict ourselves. That MAX_STACK_DEPTH limit is 
> trivially fixable if indeed someone finds its insufficient.

well .. think about it: walking more than 256 stack frames for every 
IRQ event? Getting backtraces like:

 <func_0+0x123>
 <func_1+0x123>
 <func_2+0x123>
 <func_3+0x123>
 <func_4+0x123>
 <func_5+0x123>
 <func_6+0x123>
 <func_7+0x123>
 <func_8+0x123>
 <func_9+0x123>
 <func_10+0x123>
 <func_11+0x123>
 <func_12+0x123>
 <func_13+0x123>
 <func_14+0x123>
 <func_15+0x123>
 <func_16+0x123>
 <func_17+0x123>
 <func_18+0x123>
 <func_19+0x123>
 <func_20+0x123>
 <func_21+0x123>
 <func_22+0x123>
 <func_23+0x123>
 <func_24+0x123>
 <func_25+0x123>
 <func_26+0x123>
 <func_27+0x123>
 <func_28+0x123>
 <func_29+0x123>
 <func_30+0x123>
 <func_31+0x123>
 <func_32+0x123>
 <func_33+0x123>
 <func_34+0x123>
 <func_35+0x123>
 <func_36+0x123>
 <func_37+0x123>
 <func_38+0x123>
 <func_39+0x123>
 <func_40+0x123>
 <func_41+0x123>
 <func_42+0x123>
 <func_43+0x123>
 <func_44+0x123>
 <func_45+0x123>
 <func_46+0x123>
 <func_47+0x123>
 <func_48+0x123>
 <func_49+0x123>
 <func_50+0x123>
 <func_51+0x123>
 <func_52+0x123>
 <func_53+0x123>
 <func_54+0x123>
 <func_55+0x123>
 <func_56+0x123>
 <func_57+0x123>
 <func_58+0x123>
 <func_59+0x123>
 <func_60+0x123>
 <func_61+0x123>
 <func_62+0x123>
 <func_63+0x123>
 <func_64+0x123>
 <func_65+0x123>
 <func_66+0x123>
 <func_67+0x123>
 <func_68+0x123>
 <func_69+0x123>
 <func_70+0x123>
 <func_71+0x123>
 <func_72+0x123>
 <func_73+0x123>
 <func_74+0x123>
 <func_75+0x123>
 <func_76+0x123>
 <func_77+0x123>
 <func_78+0x123>
 <func_79+0x123>
 <func_80+0x123>
 <func_81+0x123>
 <func_82+0x123>
 <func_83+0x123>
 <func_84+0x123>
 <func_85+0x123>
 <func_86+0x123>
 <func_87+0x123>
 <func_88+0x123>
 <func_89+0x123>
 <func_90+0x123>
 <func_91+0x123>
 <func_92+0x123>
 <func_93+0x123>
 <func_94+0x123>
 <func_95+0x123>
 <func_96+0x123>
 <func_97+0x123>
 <func_98+0x123>
 <func_99+0x123>
 <func_100+0x123>
 <func_101+0x123>
 <func_102+0x123>
 <func_103+0x123>
 <func_104+0x123>
 <func_105+0x123>
 <func_106+0x123>
 <func_107+0x123>
 <func_108+0x123>
 <func_109+0x123>
 <func_110+0x123>
 <func_111+0x123>
 <func_112+0x123>
 <func_113+0x123>
 <func_114+0x123>
 <func_115+0x123>
 <func_116+0x123>
 <func_117+0x123>
 <func_118+0x123>
 <func_119+0x123>
 <func_120+0x123>
 <func_121+0x123>
 <func_122+0x123>
 <func_123+0x123>
 <func_124+0x123>
 <func_125+0x123>
 <func_126+0x123>
 <func_127+0x123>
 <func_128+0x123>
 <func_129+0x123>
 <func_130+0x123>
 <func_131+0x123>
 <func_132+0x123>
 <func_133+0x123>
 <func_134+0x123>
 <func_135+0x123>
 <func_136+0x123>
 <func_137+0x123>
 <func_138+0x123>
 <func_139+0x123>
 <func_140+0x123>
 <func_141+0x123>
 <func_142+0x123>
 <func_143+0x123>
 <func_144+0x123>
 <func_145+0x123>
 <func_146+0x123>
 <func_147+0x123>
 <func_148+0x123>
 <func_149+0x123>
 <func_150+0x123>
 <func_151+0x123>
 <func_152+0x123>
 <func_153+0x123>
 <func_154+0x123>
 <func_155+0x123>
 <func_156+0x123>
 <func_157+0x123>
 <func_158+0x123>
 <func_159+0x123>
 <func_160+0x123>
 <func_161+0x123>
 <func_162+0x123>
 <func_163+0x123>
 <func_164+0x123>
 <func_165+0x123>
 <func_166+0x123>
 <func_167+0x123>
 <func_168+0x123>
 <func_169+0x123>
 <func_170+0x123>
 <func_171+0x123>
 <func_172+0x123>
 <func_173+0x123>
 <func_174+0x123>
 <func_175+0x123>
 <func_176+0x123>
 <func_177+0x123>
 <func_178+0x123>
 <func_179+0x123>
 <func_180+0x123>
 <func_181+0x123>
 <func_182+0x123>
 <func_183+0x123>
 <func_184+0x123>
 <func_185+0x123>
 <func_186+0x123>
 <func_187+0x123>
 <func_188+0x123>
 <func_189+0x123>
 <func_190+0x123>
 <func_191+0x123>
 <func_192+0x123>
 <func_193+0x123>
 <func_194+0x123>
 <func_195+0x123>
 <func_196+0x123>
 <func_197+0x123>
 <func_198+0x123>
 <func_199+0x123>
 <func_200+0x123>
 <func_201+0x123>
 <func_202+0x123>
 <func_203+0x123>
 <func_204+0x123>
 <func_205+0x123>
 <func_206+0x123>
 <func_207+0x123>
 <func_208+0x123>
 <func_209+0x123>
 <func_210+0x123>
 <func_211+0x123>
 <func_212+0x123>
 <func_213+0x123>
 <func_214+0x123>
 <func_215+0x123>
 <func_216+0x123>
 <func_217+0x123>
 <func_218+0x123>
 <func_219+0x123>
 <func_220+0x123>
 <func_221+0x123>
 <func_222+0x123>
 <func_223+0x123>
 <func_224+0x123>
 <func_225+0x123>
 <func_226+0x123>
 <func_227+0x123>
 <func_228+0x123>
 <func_229+0x123>
 <func_230+0x123>
 <func_231+0x123>
 <func_232+0x123>
 <func_233+0x123>
 <func_234+0x123>
 <func_235+0x123>
 <func_236+0x123>
 <func_237+0x123>
 <func_238+0x123>
 <func_239+0x123>
 <func_240+0x123>
 <func_241+0x123>
 <func_242+0x123>
 <func_243+0x123>
 <func_244+0x123>
 <func_245+0x123>
 <func_246+0x123>
 <func_247+0x123>
 <func_248+0x123>
 <func_249+0x123>
 <func_250+0x123>
 <func_251+0x123>
 <func_252+0x123>
 <func_253+0x123>
 <func_254+0x123>
 <func_255+0x123>
 <func_256+0x123>
 <func_257+0x123>
 <func_258+0x123>
 <func_259+0x123>
 <func_260+0x123>
 <func_261+0x123>
 <func_262+0x123>
 <func_263+0x123>
 <func_264+0x123>
 <func_265+0x123>
 <func_266+0x123>
 <func_267+0x123>
 <func_268+0x123>
 <func_269+0x123>

does that make much sense _per event_? How do you visualize it?

But yeah ... i could imagine some user-space craziness and since we 
want to align to u64 i guess that pretty much settles it to u16.

	Ingo
